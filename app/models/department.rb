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
#

class Department < ActiveRecord::Base

  belongs_to :business
  belongs_to :manager, :class_name => "User"
  belongs_to :deputy, :class_name => "User"
  has_many :jobs, :dependent => :destroy #make sure no destroy if there are still active jobs

  attr_accessible :name, :manager_id, :deputy_id
  
  validates 	:business_id,		:presence 	=> true
  validates	:name,			:presence 	=> true,
  					:length		=> { :maximum => 50 },
  					:uniqueness	=> { :scope => :business_id,
  							     :case_sensitive => false, 
  			     		     		     :message => " already exists" }
end
