# == Schema Information
#
# Table name: letter_templates
#
#  id          :integer         not null, primary key
#  description :string(255)
#  content     :text
#  created_at  :datetime
#  updated_at  :datetime
#

class LetterTemplate < ActiveRecord::Base

  attr_accessible :description, :content
  
  validates 	:description,		:presence => true,
  					:length => { :maximum => 50 }
  validates	:content,		:presence => true
  
   

end
