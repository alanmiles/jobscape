# == Schema Information
#
# Table name: tasks
#
#  id           :integer         not null, primary key
#  placement_id :integer
#  task         :string(255)
#  completed    :boolean         default(FALSE)
#  task_date    :date
#  created_at   :datetime
#  updated_at   :datetime
#

class Task < ActiveRecord::Base

  belongs_to :placement
  
  attr_accessible :task, :completed, :task_date, :placement_id
  
  validates	:placement_id,		:presence		=> true
  validates	:task,			:presence 		=> true,
  					:length			=> { :maximum => 140 },
  					:uniqueness		=> { :scope => [:placement_id, :task_date],
  					  			     :case_sensitive => false,
  					  			     :message => " has already been entered." }
  validates	:task_date,		:presence		=> true


  
end
