# == Schema Information
#
# Table name: jobs
#
#  id            :integer         not null, primary key
#  job_title     :string(255)
#  business_id   :integer
#  occupation_id :integer
#  vacancy       :boolean         default(FALSE)
#  created_at    :datetime
#  updated_at    :datetime
#

class Job < ActiveRecord::Base

  attr_accessible :job_title, :occupation_id, :vacancy
  
  belongs_to :business
  belongs_to :occupation
  
  validates :job_title, :presence 	=> true,
  			:length		=> { :maximum => 50 },
  			:uniqueness 	=> { :scope => :business_id, 
  			     		     :message => " already exists" }
  validates :business_id, :presence	=> true
  validates :occupation_id, :presence	=> true
  
  default_scope :order => 'jobs.job_title'			     		     
end
