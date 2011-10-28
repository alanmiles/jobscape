class Application < ActiveRecord::Base


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
#  employer_shortlist     :boolean         default(FALSE)
#  created_at             :datetime
#  updated_at             :datetime
#  personal_statement     :string(255)
#  responsibilities_score :integer         default(0)
#

  
  belongs_to :vacancy
  belongs_to :user
  has_many :applicqualities, :dependent => :destroy
  has_many :applicresponsibilities, :dependent => :destroy
  has_many :applicrequirements, :dependent => :destroy
  accepts_nested_attributes_for :applicqualities
  accepts_nested_attributes_for :applicresponsibilities
  accepts_nested_attributes_for :applicrequirements
  
  attr_accessible :submitted, :next_action, :submission_date, :requirements_score, :qualities_score, :responsibilities_score, 
  			:portrait_score, :employer_shortlist, :user_id, :personal_statement, :applicresponsibilities_attributes,
                  	:applicqualities_attributes, :applicrequirements_attributes
  
  ACTION_TYPES = [
    ["It's not for me, thanks.", 0],
    ["Yes, please bookmark for now.", 1],
    ["Yes, I'd like to apply now.", 2]
  ]
  
  BOOKMARK_TYPES = [
    ["Not applying yet - but leave bookmark in place.", 1],
    ["Yes, I'd like to apply now.", 2]
  ]
  
  after_save :build_associated_tables
  
  validates	:vacancy_id,		:presence	=> true,
  					:uniqueness	=> { :scope => :user_id }
  validates	:user_id,		:presence	=> true
  validates 	:next_action,		:presence	=> true
  
  def has_applicqualities?
    self.applicqualities.count > 0
  end
  
  def has_applicresponsibilities?
    self.applicresponsibilities.count > 0
  end
  
  def has_applicrequirements?
    self.applicrequirements.count > 0
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

