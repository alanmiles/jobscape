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
  
  validates :user_id,		:presence 	=> true
  validates :job,		:presence 	=> true,		
  				:length		=> { :maximum => 50 }
  validates :years,		:presence 	=> true,
  				:numericality	=> { :integer => true }	


end
