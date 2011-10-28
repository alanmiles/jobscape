# == Schema Information
#
# Table name: reviews
#
#  id                      :integer         not null, primary key
#  reviewee_id             :integer
#  reviewer_id             :integer
#  reviewer_name           :string(255)
#  reviewer_email          :string(255)
#  secret_code             :string(255)
#  job_id                  :integer
#  responsibilities_score  :integer         default(0)
#  attributes_score        :integer         default(0)
#  achievements            :string(255)
#  problems                :string(255)
#  observations            :string(255)
#  change_responsibilities :string(255)
#  change_goals            :string(255)
#  change_attributes       :string(255)
#  plan                    :string(255)
#  completed               :boolean         default(FALSE)
#  completion_date         :datetime
#  created_at              :datetime
#  updated_at              :datetime
#

class Review < ActiveRecord::Base

  belongs_to :reviewer, :class_name => "User"
  belongs_to :reviewee, :class_name => "User"
  belongs_to :job
  has_many :reviewqualities, :dependent => :destroy
  has_many :reviewresponsibilities, :dependent => :destroy
  has_many :reviewgoals, :through => :reviewresponsibilities
  
  accepts_nested_attributes_for :reviewqualities
  accepts_nested_attributes_for :reviewresponsibilities
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  attr_accessible :reviewee_id, :reviewer_id, :reviewer_name, :job_id, :completion_date, :reviewer_email, :secret_code, 
  		 :reviewresponsibilities_attributes, :reviewqualities_attributes
  
  after_save :build_review_tables
  
  validates	:reviewee_id,		:presence 	=> true
  validates	:reviewer_id,		:presence	=> true
  validates	:job_id,		:presence 	=> true
  validates	:reviewer_name,		:presence	=> true,
  					:length		=> { :maximum => 50 }
  validates	:responsibilities_score, :presence	=> true
  validates	:attributes_score,	:presence 	=> true
  validates	:reviewer_email, 	:format 	=> { :with => email_regex, :allow_blank => true }
  validates	:secret_code,		:length		=> { :maximum => 4, :allow_blank => true }
  validates	:achievements,		:length		=> { :maximum => 255, :allow_blank => true }
  validates	:problems,		:length		=> { :maximum => 255, :allow_blank => true }
  validates	:observations,		:length		=> { :maximum => 255, :allow_blank => true } 
  validates	:change_responsibilities,	:length		=> { :maximum => 255, :allow_blank => true }
  validates	:change_goals,		:length		=> { :maximum => 255, :allow_blank => true }
  validates	:change_attributes,	:length		=> { :maximum => 255, :allow_blank => true }
  validates	:plan,			:length		=> { :maximum => 255, :allow_blank => true }
  
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
  
  private
  
    def build_review_tables
      @job = Job.find(self.job_id)
      
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
end
