# == Schema Information
#
# Table name: contents
#
#  id         :integer         not null, primary key
#  header     :string(255)
#  content    :text
#  created_at :datetime
#  updated_at :datetime
#

class Content < ActiveRecord::Base

  attr_accessible :header, :content
  
  validates	:header,  	:presence 		=> true,
                                :uniqueness		=> true,
                                :length			=> { :maximum => 50 }
  validates	:content,	:presence		=> true
  
end
