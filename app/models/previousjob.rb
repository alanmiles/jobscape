# == Schema Information
#
# Table name: previousjobs
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  job        :string(255)
#  years      :integer         default(0)
#  position   :integer
#  created_at :datetime
#  updated_at :datetime
#

class Previousjob < ActiveRecord::Base

  attr_accessible :job, :years, :position
  
  belongs_to :user
  
  acts_as_list :scope => :user
  
  SERVICE_TYPES = [
    ["Less than a year", 0],
    ["1-2 years", 1],
    ["2-5 years", 2],
    ["5-10 years", 3],
    ["more than 10 years", 4]
  ]
  
  
  validates :user_id,		:presence 	=> true
  validates :job,		:presence 	=> true,		
  				:length		=> { :maximum => 50 }
  validates :years,		:presence 	=> true
  				#:inclusion	=> { :in => [0..4] }	

  def service_length
    if years == 0
      return "for less than a year"
    elsif years == 1
      return "for 1-2 years"
    elsif years == 2
      return "for 2-5 years"
    elsif years == 3
      return "for 5-10 years"
    else
      return "for more than 10 years"
    end
  end
  
  def job_details
    "#{self.job} #{self.service_length}"  
  end
end
