# == Schema Information
#
# Table name: placements
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  job_id     :integer
#  current    :boolean         default(TRUE)
#  created_at :datetime
#  updated_at :datetime
#

class Placement < ActiveRecord::Base

  attr_accessible :user_id, :job_id, :current
  
  belongs_to :user
  belongs_to :job
  
  validates :user_id,		:presence 	=> true
  validates :job_id,		:presence 	=> true,
  				:uniqueness 	=> { :scope => :user_id }
  
  def self.individual_make(user, job)
    @user = User.find(user.id)
    if @user.placements.count > 0
      self.cancel_old(@user)
    end
    self.create(:user_id => user.id, :job_id => job.id)
  end
  
  def self.cancel_old(user)
    @placements = self.where("user_id = ? and current = ?", user.id, true)
    @placements.each do |placement|
      placement.update_attribute(:current, false)
    end 
  end
end
