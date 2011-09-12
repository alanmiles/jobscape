# == Schema Information
#
# Table name: employees
#
#  id          :integer         not null, primary key
#  user_id     :integer
#  business_id :integer
#  officer     :boolean         default(FALSE)
#  created_at  :datetime
#  updated_at  :datetime
#

class Employee < ActiveRecord::Base

  attr_accessible :user_id, :business_id, :officer
  
  belongs_to :user
  belongs_to :business
  
  validates :user_id,		:presence 	=> true
  validates :business_id,	:presence 	=> true,
  				:uniqueness 	=> { :scope => :user_id }
  
  def role
    if officer?
      return "Officer"
    else
      return "Employee"
    end
  end
  
  def business_location
    "#{self.business.name}, #{self.business.city}"
  end

end
