# == Schema Information
#
# Table name: outlines
#
#  id         :integer         not null, primary key
#  job_id     :integer
#  role       :text            default("Your role is to ")
#  qualities  :text            default("To do this job well, you need ")
#  importance :text            default("The job is important to the organization because ")
#  created_at :datetime
#  updated_at :datetime
#

class Outline < ActiveRecord::Base

  belongs_to :job
  
  attr_accessible :role, :qualities, :importance, :job_id
  
  validates	:job_id,  	:presence 		=> true,
                                :uniqueness		=> true

  def role_updated?
    role != "Your role is to "
  end
  
  def qualities_updated?
    qualities != "To do this job well, you need "
  end
  
  def importance_updated?
    importance != "The job is important to the organization because "
  end
  
  def complete?
    role_updated? && qualities_updated? && importance_updated?
  end
end
