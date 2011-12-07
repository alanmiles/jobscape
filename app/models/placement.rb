# == Schema Information
#
# Table name: placements
#
#  id            :integer         not null, primary key
#  user_id       :integer
#  job_id        :integer
#  current       :boolean         default(TRUE)
#  created_at    :datetime
#  updated_at    :datetime
#  started_job   :date
#  department_id :integer
#

class Placement < ActiveRecord::Base

  attr_accessible :user_id, :job_id, :current, :started_job, :department_id
  
  belongs_to :user
  belongs_to :job
  belongs_to :department
  has_many :reviews, :dependent => :destroy
  has_many :tasks, :dependent => :destroy
  has_many :targets, :dependent => :destroy
  
  before_save :assign_department
  
  validates :user_id,		:presence 	=> true
  validates :job_id,		:presence 	=> true,
  				:uniqueness 	=> { :scope => [:user_id, :started_job, :current],
  				                     :message => " has already been assigned to this employee on the same start-date.  Try setting a different start-date or delete the previous record." }
  
  def self.individual_make(user, job)
    @user = User.find(user.id)
    if @user.placements.count > 0
      self.cancel_old(@user)
    end
    self.create(:user_id => user.id, :job_id => job.id, :started_job => Date.today)
  end
  
  def self.cancel_old(user)   #assumes only one business - for 'Individual' accounts
    @placements = self.where("user_id = ? and current = ?", user.id, true)
    @placements.each do |placement|
      placement.update_attribute(:current, false)
    end 
  end
  
  def job_dept
    return "#{self.job.job_title} - #{self.department.name}"
  end
  
  def completed_formal_reviews
    self.reviews.where("reviews.completed = ? and reviews.reviewer_id != ? 
      and reviews.reviewer_name = ?", true, self.user_id, nil).order("reviews.completion_date DESC")
  end
  
  def has_completed_formal_reviews?
    nmbr = self.completed_formal_reviews.count
    nmbr > 0
  end
  
  def current_targets
    self.targets.where("targets.achieved = ? and targets.cancelled = ?", 
    			false, false).order("targets.target_date")
  end
  
  def history_targets
    self.targets.where("targets.achieved = ? or targets.cancelled = ?", 
    			true, true).order("targets.target_date DESC")
  end
  
  private
  
    def assign_department
      if self.department_id.nil?
        @job = Job.find(self.job_id)
        self.department_id = @job.department_id      
      end
    end
end
