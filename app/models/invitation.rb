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
#

class Invitation < ActiveRecord::Base

  belongs_to :business
  belongs_to :received_invitation, :class_name => "User"
  belongs_to :issued_invitation, :class_name => "User"
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  attr_accessible :name, :email, :inviter_id, :invitee_id
  
  validates	:business_id,		:presence	=> true
  validates	:name,			:presence	=> true,
  					:length		=> { :maximum => 50 }
  validates	:email,			:presence	=> true,
  					:format 	=> { :with => email_regex },
  					:uniqueness 	=> { :case_sensitive => false }
  validates	:security_code,		:presence	=> true,
  					:length		=> { :minimum => 6, :maximum => 6 }
  validates	:inviter_id,		:presence	=> true
  validates	:invitee_id,		:presence	=> true,
  					:uniqueness	=> { :scope => :business_id,
  							     :message => " has already received an invitation." }
  					
  					 			
end
