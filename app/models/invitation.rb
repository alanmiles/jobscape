# == Schema Information
#
# Table name: invitations
#
#  id            :integer         not null, primary key
#  business_id   :integer
#  name          :string(255)
#  email         :string(255)
#  security_code :string(255)
#  inviter_id    :integer
#  invitee_id    :integer
#  created_at    :datetime
#  updated_at    :datetime
#  signed_up     :boolean         default(FALSE)
#  staff_no      :integer
#  job_id        :integer
#

class Invitation < ActiveRecord::Base

  belongs_to :business
  belongs_to :job
  belongs_to :received_invitation, :class_name => "User"
  belongs_to :issued_invitation, :class_name => "User"
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  attr_accessible :name, :email, :inviter_id, :invitee_id, :signed_up, :security_code, :staff_no, :job_id
  
  validates	:business_id,		:presence	=> true
  validates	:name,			:presence	=> true,
  					:length		=> { :maximum => 50 }
  validates	:email,			:presence	=> true,
  					:format 	=> { :with => email_regex },
  					:uniqueness 	=> { :case_sensitive => false, 
  					                     :scope => :business_id,
  					                     :message => "has already received an invitation for this business.  Delete the first invitation
    					                     if you want to send a new one." },
    					:not_hired	=> true
    					                     
  validates	:security_code,		:presence	=> true,
  					:length		=> { :minimum => 6, :maximum => 6 }
  validates	:inviter_id,		:presence	=> true
  validates	:staff_no,		:numericality 	=> { :only => :integer, :allow_blank => true }
  validates	:staff_no,		:duplicate_id	=> true, :if => :staff_no_set?
  validates	:job_id,		:presence	=> true
  
  def staff_no_set?
    self.staff_no != nil
  end
  
  def self.generate_code
    alphanumerics = [('0'..'9'),('a'..'z')].map {|range| range.to_a}.flatten
    (0...6).map { alphanumerics[Kernel.rand(alphanumerics.size)] }.join
  end 
  
  def asked_by
    @user = User.find(self.inviter_id)
    @user.name 
  end
  
  def corresponds_to_user?
    @mail = self.email
    @user = User.find_by_email(@mail)
    if @user.nil?
      return false
    else
      return true
    end
  end
  				 			
end
