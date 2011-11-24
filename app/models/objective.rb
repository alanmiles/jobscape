# == Schema Information
#
# Table name: objectives
#
#  id          :integer         not null, primary key
#  business_id :integer
#  objective   :string(255)
#  focus       :integer
#  measurement :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class Objective < ActiveRecord::Base

  attr_accessible :objective, :focus, :measurement
  
  belongs_to :business
  
  FOCUS_TYPES = [
    ["Profit", 1],
    ["Customers", 2],
    ["Employees", 3],
    ["Processes", 4]
  ]
  
  validates	:business_id,		:presence 	=> true
  validates	:objective,		:presence 	=> true,
  					:length		=> { :maximum => 255 },
  					:uniqueness	=> { :scope => [:business_id, :focus],
  					  			     :case_sensitive => false,
  					  			     :message => " has already been entered." }
  validates	:focus,			:presence	=> true,
  					:inclusion	=> { :in => 1..4 }
  validates	:measurement,		:presence	=> true,
  					:length		=> { :maximum => 255 }

  def focus_name
    if focus == 1
      return "Profit"
    elsif focus == 2
      return "Customers"
    elsif focus == 3
      return "Employees"
    else
      return "Processes"
    end
  end

  
  
  
end
