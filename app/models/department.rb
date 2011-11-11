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
  has_many :placements, :through => :jobs

  attr_accessible :name, :manager_id, :deputy_id, :hidden
  
  validates 	:business_id,		:presence 	=> true
  validates	:name,			:presence 	=> true,
  					:length		=> { :maximum => 50 },
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
  
  def self.inactive_discovered?(business, name)
    @cnt = self.where("business_id = ? and name = ? and hidden = ?", business.id, name, true).count
    @cnt > 0
  end
  
end
