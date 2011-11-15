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
#  ref_no      :integer
#  left        :boolean         default(FALSE)
#

class Employee < ActiveRecord::Base

  attr_accessible :user_id, :business_id, :officer, :ref_no, :left
  
  belongs_to :user
  belongs_to :business
  
  before_destroy :remove_placements
  
  validates :user_id,		:presence 	=> true, 
  				:uniqueness 	=> { :scope => :business_id,
  						     :message => " already belongs to this business - check 'Former Employees' 
  						        if you can't see the record in the employee list" }
  validates :business_id,	:presence 	=> true
  validates :ref_no,		:presence 	=> true,
  				:uniqueness	=> { :scope => :business_id }
  				
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
  
  def self.only_private(user)
    @biz = 0
    @business = Business.find_by_name("Biz_#{user.id.to_s}")
    @biz = @business.id unless @business == nil
    self.where("business_id = ? and user_id = ?", @biz, user.id)
  end
  
  def self.all_except_private(user)
    @biz = 0
    @private_biz = Business.find_by_name("Biz_#{user.id.to_s}")
    @biz = @private_biz.id unless @private_biz == nil
    self.where("business_id != ? and user_id = ?", @biz, user.id)
  end
  
  private
  
    def remove_placements
      @user = User.find(self.user_id)
      @business = Business.find(self.business_id)
      @jobs = @user.jobs.where("jobs.business_id = ?", @business.id)
      @jobs.each do |job|
        @placements = Placement.where("user_id = ? and job_id = ?", @user.id, job.id)
        @placements.each do |p|
          p.destroy
        end
      end
    
      @invitations = @business.invitations.where("email = ?", @user.email)
      @invitations.each do |i|
        i.destroy
      end
    end
    

end
