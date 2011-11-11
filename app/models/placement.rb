# == Schema Information
#
# Table name: placements
#
#  id          :integer         not null, primary key
#  user_id     :integer
#  job_id      :integer
#  current     :boolean         default(TRUE)
#  created_at  :datetime
#  updated_at  :datetime
#  started_job :date
#

class Placement < ActiveRecord::Base

  attr_accessible :user_id, :job_id, :current, :started_job
  
  belongs_to :user
  belongs_to :job
  has_many :reviews, :dependent => :destroy
  
  validates :user_id,		:presence 	=> true
  validates :job_id,		:presence 	=> true,
  				:uniqueness 	=> { :scope => [:user_id, :started_job],
  				                     :message => " has already been assigned to this employee." }
  
  def self.individual_make(user, job)
    @user = User.find(user.id)
    if @user.placements.count > 0
      self.cancel_old(@user)
    end
    self.create(:user_id => user.id, :job_id => job.id, :started_job => Date.today)
  end
  
  def self.cancel_old(user)   #assumes only one business - for 'Individual' accounts
    @placements = self.where("user_id = ? and current = ?", user.id, true)
    @placements.each do |placement|
      placement.update_attribute(:current, false)
    end 
  end
  
  def job_dept
    return "#{self.job.job_title} - #{self.job.department.name}"
  end
  
  def completed_formal_reviews
    self.reviews.where("reviews.completed = ? and reviews.reviewer_id != ? 
      and reviews.reviewer_name = ?", true, self.user_id, nil).order("reviews.completion_date DESC")
  end
  
  def has_completed_formal_reviews?
    nmbr = self.completed_formal_reviews.count
    nmbr > 0
  end
  
  #def make_this_only_current_for(user, business)
  #  @other_current = Placement.w
  #end
end
