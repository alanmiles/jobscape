# == Schema Information
#
# Table name: reviews
#
#  id                        :integer         not null, primary key
#  reviewee_id               :integer
#  reviewer_id               :integer
#  reviewer_name             :string(255)
#  reviewer_email            :string(255)
#  secret_code               :string(255)
#  job_id                    :integer
#  responsibilities_score    :integer         default(0)
#  attributes_score          :integer         default(0)
#  achievements              :string(255)
#  problems                  :string(255)
#  observations              :string(255)
#  change_responsibilities   :string(255)
#  change_goals              :string(255)
#  change_attributes         :string(255)
#  plan                      :string(255)
#  responsibilities_complete :boolean         default(FALSE)
#  qualities_complete        :boolean         default(FALSE)
#  comments_complete         :boolean         default(FALSE)
#  completed                 :boolean         default(FALSE)
#  completion_date           :datetime
#  created_at                :datetime
#  updated_at                :datetime
#  placement_id              :integer
#  review_type               :integer         default(1)
#  cancel                    :boolean         default(FALSE)
#  cancellation_reason       :string(255)
#  business_id               :integer
#  consent                   :boolean
#  contribution              :integer
#  seen_by_reviewee          :boolean         default(TRUE)
#

class Review < ActiveRecord::Base

  belongs_to :reviewer, :class_name => "User"
  belongs_to :reviewee, :class_name => "User"
  belongs_to :job
  belongs_to :placement
  belongs_to :business
  has_many :reviewqualities, :dependent => :destroy
  has_many :reviewresponsibilities, :dependent => :destroy
  has_many :reviewgoals, :through => :reviewresponsibilities
  
  accepts_nested_attributes_for :reviewqualities
  accepts_nested_attributes_for :reviewresponsibilities
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  attr_accessible :reviewee_id, :reviewer_id, :reviewer_name, :job_id, :completed, :completion_date, :reviewer_email, :secret_code, :comments_complete,
  		 :reviewresponsibilities_attributes, :reviewqualities_attributes, :responsibilities_complete, :qualities_complete, :achievements,
  		 :problems, :observations, :change_responsibilities, :change_goals, :change_attributes, :plan, :responsibilities_score, :review_type,
  		 :attributes_score, :placement_id, :cancel, :cancellation_reason, :business_id, :consent, :seen_by_reviewee, :created_at
  
  before_save :assign_business
  before_save :calculate_contribution
  after_save :build_review_tables
  
  validates	:reviewee_id,		:presence 	=> true
  validates	:reviewer_id,		:presence	=> true
  validates	:job_id,		:presence 	=> true
  validates	:placement_id,		:presence	=> true
  validates	:reviewer_name,		:presence	=> true,
  					:length		=> { :maximum => 50 }
  validates	:responsibilities_score, :presence	=> true
  validates	:attributes_score,	:presence 	=> true
  validates	:reviewer_email, 	:format 	=> { :with => email_regex, :allow_blank => true }
  validates	:secret_code,		:length		=> { :maximum => 6, :allow_blank => true }
  validates	:achievements,		:length		=> { :maximum => 255, :allow_blank => true }
  validates	:problems,		:length		=> { :maximum => 255, :allow_blank => true }
  validates	:observations,		:length		=> { :maximum => 255, :allow_blank => true } 
  validates	:change_responsibilities,	:length		=> { :maximum => 255, :allow_blank => true }
  validates	:change_goals,		:length		=> { :maximum => 255, :allow_blank => true }
  validates	:change_attributes,	:length		=> { :maximum => 255, :allow_blank => true }
  validates	:plan,			:length		=> { :maximum => 255, :allow_blank => true }
  validates	:cancellation_reason,	:length		=> { :maximum => 100, :allow_blank => true }
  
  def has_reviewqualities?
    nmbr = self.reviewqualities.count
    nmbr > 0
  end
  
  def has_reviewresponsibilities?
    nmbr = self.reviewresponsibilities.count
    nmbr > 0
  end
  
  def self_appraisal?
    reviewer_id == reviewee_id && reviewer_email.blank?
  end
  
  def self.generate_secret_code
    alphanumerics = [('0'..'9'),('a'..'z')].map {|range| range.to_a}.flatten
    (0...6).map { alphanumerics[Kernel.rand(alphanumerics.size)] }.join
  end 
  
  def started?
    responsibilities_complete? || qualities_complete? || comments_complete?
  end
  
  def elements_complete?
    responsibilities_complete? && qualities_complete? && comments_complete?
  end
  
  def gather_achieved_goals
    @responsibilities = self.reviewresponsibilities
    @responsibilities.each do |r|
      @achieved = r.reviewgoals.where("reviewgoals.achieved = ?", true).count
      r.update_attribute(:achieved_goals, @achieved) 
    end
  end
  
  def calculate_achievement_scores
    @responsibilities = self.reviewresponsibilities
    @responsibilities.each do |r|
      @score = sprintf("%.2f", (r.rating_value.to_f * r.achieved_goals.to_f / r.total_goals.to_f))
      r.update_attribute(:achievement_score, @score)
    end
  end
  
  def score_for_responsibilities
    @achieved = self.reviewresponsibilities.sum("achievement_score")
    @possible = self.reviewresponsibilities.sum("rating_value")
    @score = sprintf("%.0f", (@achieved.to_f/@possible.to_f * 50))
  end
  
  def adjust_attribute_scores
    @qualities = self.reviewqualities
    @qualities.each do |q|
      if q.position > 5
        @multiplier = 2
      else
      	@multiplier = 3
      end
      @score = q.reviewer_score * @multiplier
      q.update_attribute(:adjusted_score, @score)      
    end
  end
  
  def score_for_qualities
    @total = (self.reviewqualities.sum("adjusted_score") / 2)
  end

  def total_score
    responsibilities_score + attributes_score
  end 
  
  def contribution_score
    @job = Job.find(self.job_id)
    @plan = Plan.find_by_job_id(@job)
    @jvalue = @plan.job_value
    score = (@jvalue * total_score / 100).to_i 
  end
  
  def editable?
    if completion_date == nil
      return true
    else
      if Time.now > completion_date + 7.days
        return false
      else
        return true
      end
    end
  end
  
  def editable_date
    if completion_date == nil
      created_at + 7.days
    else
      completion_date + 7.days
    end
  end
  
  def self.completed_for(user, business)
    self.where("reviewee_id = ? and completed = ? and business_id = ?", user.id, true, business.id).order("completion_date DESC")
  end
  
  def scheduled_completion
    self.created_at + 14.days
  end
   
  private
  
    def build_review_tables
      @job = Job.find(self.job_id)
      @user = User.find(self.reviewee_id)
      
      if @user.has_outdated_reviews?
        @old_reviews = @user.outdated_reviews
        @old_reviews.each do |old|
          old.destroy
        end
      end
      
      unless self.has_reviewqualities?
        @jobqualities = @job.jobqualities.order("jobqualities.position")
        @jobqualities.each do |q|
          @reviewquality = self.reviewqualities.build
          @reviewquality.quality_id = q.quality_id
          @reviewquality.position = q.position
          @reviewquality.save
        end
      end
      
      unless self.has_reviewresponsibilities?
        @responsibilities = @job.responsibilities.where("responsibilities.removed = ?", false).order("responsibilities.rating DESC")
        pstn = 0
        @responsibilities.each do |r|
          pstn = pstn + 1
          @reviewresponsibility = self.reviewresponsibilities.build
          @reviewresponsibility.responsibility_id = r.id
          @reviewresponsibility.rating_value = r.rating
          @reviewresponsibility.position = pstn
          @reviewresponsibility.total_goals = r.count_current_goals
          @reviewresponsibility.save
        end
      end
      
    end
    
    def assign_business
      if self.business_id.nil?
        @job = Job.find(self.job_id)
        self.business_id = @job.business_id
      end
    end
    
    def calculate_contribution
      if self.completed? && self.elements_complete? && (self.reviewer_id != self.reviewee_id)
        self.contribution = self.contribution_score
      end
    end 
end
