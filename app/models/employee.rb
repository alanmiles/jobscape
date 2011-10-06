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

end
