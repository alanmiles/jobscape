# == Schema Information
#
# Table name: applications
#
#  id                     :integer         not null, primary key
#  vacancy_id             :integer
#  user_id                :integer
#  next_action            :integer         default(0)
#  submitted              :boolean         default(FALSE)
#  submission_date        :datetime
#  requirements_score     :integer         default(0)
#  qualities_score        :integer         default(0)
#  portrait_score         :integer         default(0)
#  created_at             :datetime
#  updated_at             :datetime
#  personal_statement     :string(255)
#  responsibilities_score :integer         default(0)
#  employer_action        :integer         default(0)
#  hygwit_score           :integer         default(0)
#

class Application < ActiveRecord::Base


  
  belongs_to :vacancy
  belongs_to :user
  has_many :applicqualities, :dependent => :destroy
  has_many :applicresponsibilities, :dependent => :destroy
  has_many :applicrequirements, :dependent => :destroy
  accepts_nested_attributes_for :applicqualities
  accepts_nested_attributes_for :applicresponsibilities
  accepts_nested_attributes_for :applicrequirements
  
  attr_accessible :submitted, :next_action, :submission_date, :requirements_score, :qualities_score, :responsibilities_score, 
  			:portrait_score, :employer_action, :user_id, :personal_statement, :applicresponsibilities_attributes,
                  	:applicqualities_attributes, :applicrequirements_attributes, :hygwit_score
  
  ACTION_TYPES = [
    ["It's not for me, thanks.", 0],
    ["Yes, please bookmark for now.", 1],
    ["Yes, I'd like to apply now.", 2]
  ]
  
  BOOKMARK_TYPES = [
    ["Not applying yet - but leave bookmark in place.", 1],
    ["Yes, I'd like to apply now.", 2]
  ]
  
  EMPLOYER_DECISIONS = [
    ["No decision yet", 0],
    ["Rejected without interview", 1],
    ["Consider for interview", 2],
    ["Interview arranged", 3],
    ["Interview completed", 4],
    ["Rejected after interview", 5],
    ["Shortlisted after interview", 6],
    ["Shortlisted but rejected", 7],
    ["Offer made", 8],
    ["Hired", 9]
  ]
  
  after_save :build_associated_tables
  
  validates	:vacancy_id,		:presence	=> true,
  					:uniqueness	=> { :scope => :user_id }
  validates	:user_id,		:presence	=> true
  validates 	:next_action,		:presence	=> true
  validates 	:employer_action,	:presence 	=> true
  validates	:hygwit_score,		:numericality 	=> [:integer => true, :allow_zero => true]
  
  def has_applicqualities?
    self.applicqualities.count > 0
  end
  
  def has_applicresponsibilities?
    self.applicresponsibilities.count > 0
  end
  
  def has_applicrequirements?
    self.applicrequirements.count > 0
  end
  
  def submitted_today?
    Time.now <= submission_date + 6440.minutes
  end
  
  def self.bookmarks(user)
    self.joins(:vacancy).where("user_id = ? and next_action = ? and vacancies.close_date >= ?", user.id, 1, Date.today)
  end
  
  def self.no_bookmarks?(user)
    result = self.bookmarks(user).count
    result == 0
  end
  
  def self.completed(user)
    self.where("user_id = ? and next_action = ? and submitted = ?", user.id, 2, true)
  end
  
  def self.none_made?(user)
    result = self.completed(user).count
    result == 0
  end
  
  def self.incomplete(user)
    self.joins(:vacancy).where("user_id = ? and next_action = ? and submitted = ? and vacancies.close_date >= ?", user.id, 2, false, Date.today)
  end
  
  def self.incomplete?(user)
    result = self.incomplete(user).count
    result == 0
  end
  
  def sum_of_qualities
    self.applicqualities.sum(:applicant_score)
  end
  
  def sum_of_requirements
    self.applicrequirements.sum(:applicant_score)
  end
  
  def sum_of_responsibilities
    self.applicresponsibilities.sum(:applicant_score)
  end
  
  def total_score
    responsibilities_score + qualities_score + requirements_score
  end
  
  def describe_employer_action
    if employer_action == 0
      act = "No decision yet"
    elsif employer_action == 1
      act = "Rejected without interview"
    elsif employer_action == 2
      act = "Consider for interview"
    elsif employer_action == 3
      act = "Interview arranged" 
    elsif employer_action == 4
      act = "Interview completed"
    elsif employer_action == 5
      act = "Rejected after interview"
    elsif employer_action == 6
      act = "Shortlisted after interview"
    elsif employer_action == 7
      act = "Shortlisted but rejected"
    elsif employer_action == 8
      act = "Offer made"
    elsif employer_action == 9
      act = "Hired"
    end
  end
  
  def calculate_hygwit_score
    @job = Job.find(self.vacancy.job_id)
    @cnt_requirements = @job.plan.count_requirements
    if @cnt_requirements > 5
      @cnt_requirements = 5
    end
    @req_score = @cnt_requirements * 3
    @possible_score = 30 + @req_score
    @h_score = total_score * 100 / @possible_score
    self.hygwit_score = @h_score
    self.save
  end
  
  private
  
    def build_associated_tables
      if next_action == 2
        @vacancy = Vacancy.find(self.vacancy_id)
        @job = Job.find(@vacancy.job_id)
        @plan = Plan.find_by_job_id(@job.id)
      
        unless has_applicresponsibilities?
          position = 0
          @responsibilities = @plan.top_five_responsibilities
	  @responsibilities.each do |responsibility|
	    position = position + 1
            @applicresp = self.applicresponsibilities.build
            @applicresp.responsibility_id = responsibility.id
            @applicresp.position = position
            @applicresp.save
          end     
        end
      
        unless has_applicqualities?
          position = 0
          @qualities = @plan.top_five_attributes
          @qualities.each do |quality|
            position = position + 1
            @applicqlty = self.applicqualities.build
            @applicqlty.quality_id = quality.quality_id
            @applicqlty.position = position
            @applicqlty.save        
          end
        end
      
        unless has_applicrequirements?
          position = 0
          @requirements = @plan.top_five_requirements
          @requirements.each do |requirement|
            position = position + 1
            @applicreqmt = self.applicrequirements.build
            @applicreqmt.requirement_id = requirement.id
            @applicreqmt.position = position
            @applicreqmt.save
          end
        end  
      end
    end
    
end

