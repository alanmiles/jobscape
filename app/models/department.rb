# == Schema Information
#
# Table name: departments
#
#  id          :integer         not null, primary key
#  business_id :integer
#  name        :string(255)
#  manager_id  :integer
#  deputy_id   :integer
#  created_at  :datetime
#  updated_at  :datetime
#  hidden      :boolean         default(FALSE)
#

class Department < ActiveRecord::Base

  belongs_to :business
  belongs_to :manager, :class_name => "User"
  belongs_to :deputy, :class_name => "User"
  has_many :jobs, :dependent => :destroy #make sure no destroy if there are still active jobs
  has_many :placements
  has_many :users, :through => :placements, :uniq => true
  has_many :reviews, :through => :jobs

  attr_accessible :name, :manager_id, :deputy_id, :hidden
  
  validates 	:business_id,		:presence 	=> true
  validates	:name,			:presence 	=> true,
  					:length		=> { :maximum => 20 },
  					:uniqueness	=> { :scope => :business_id,
  							     :case_sensitive => false, 
  			     		     		     :message => " already exists" }
  
  def active_placements
    self.placements.where("placements.current = ?", true)
  end
  
  def headcount
    self.active_placements.count
  end
  
  def empty?
    self.headcount == 0
  end
  
  def position_count
    self.jobs.where("jobs.inactive = ?", false).count
  end
  
  def inactive_count
    self.jobs.where("jobs.inactive = ?", true).count
  end
  
  def has_active_jobs?
    self.position_count > 0
  end
  
  def has_inactive_jobs?
    self.inactive_count > 0
  end
  
  def current_team
    self.users.joins(:placements).where("placements.current = ?", true).order("users.name")
  end
  
  def self.inactive_discovered?(business, name)
    @cnt = self.where("business_id = ? and name = ? and hidden = ?", business.id, name, true).count
    @cnt > 0
  end
   
  def calculation_date
    if self.created_at > Date.today - 365.days
      @date = self.created_at
    else
      @date = Date.today - 365.days
    end
  end
  
  def calculation_days
    ((Time.now - self.calculation_date)/24/60/60).to_i
  end
  
  def reviews_in_calculation_period
    self.reviews.where("reviews.completed = ? and reviews.completion_date >= ? and reviews.reviewer_id != reviews.reviewee_id", true, self.calculation_date)
  end
  
  def self_appraisals_in_calculation_period
    self.reviews.where("reviews.completed = ? and reviews.completion_date >= ? and reviews.reviewer_id = reviews.reviewee_id", true, self.calculation_date)
  end
  
  def review_frequency_in_days
    (self.calculation_days * self.headcount / self.reviews_in_calculation_period.count).to_i
  end
  
  def self_appraisal_frequency_in_days
    (self.calculation_days * self.headcount / self.self_appraisals_in_calculation_period.count).to_i
  end
  
  def avg_review_score_in_calculation_period
    @reviews = self.reviews_in_calculation_period
    @avg = (@reviews.average(:responsibilities_score) + @reviews.average(:attributes_score))
  end
  
end
