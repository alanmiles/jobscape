# == Schema Information
#
# Table name: plans
#
#  id                  :integer         not null, primary key
#  job_id              :integer
#  responsibilities    :boolean         default(FALSE)
#  goals               :boolean         default(FALSE)
#  personal_attributes :boolean         default(FALSE)
#  recruitment_factors :boolean         default(FALSE)
#  summary             :boolean         default(FALSE)
#  evaluation          :boolean         default(FALSE)
#  job_value           :integer
#  updated_by          :integer
#  created_at          :datetime
#  updated_at          :datetime
#

class Plan < ActiveRecord::Base

  belongs_to :job
  has_many :responsibilities, :dependent => :destroy
  
  validates	:job_id,  	:presence 		=> true,
                                :uniqueness		=> true
                                
  
  def count_responsibilities
    self.responsibilities.count(:all, :conditions => ["responsibilities.removed = ?", false]) 
  end
  
  def has_responsibilities?
    count_responsibilities > 0
  end
  
  def complete?
    #correct during build
    count_responsibilities > 1
  end
end
