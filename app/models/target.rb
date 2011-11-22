# == Schema Information
#
# Table name: targets
#
#  id           :integer         not null, primary key
#  placement_id :integer
#  target       :string(255)
#  target_date  :date
#  achieved     :boolean         default(FALSE)
#  cancelled    :boolean         default(FALSE)
#  note         :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

class Target < ActiveRecord::Base

  belongs_to :placement
  
  attr_accessible :placement_id, :target, :target_date, :achieved, :cancelled, :note
  
  validates	:placement_id,		:presence		=> true
  validates	:target,		:presence 		=> true,
  					:length			=> { :maximum => 255 },
  					:uniqueness		=> { :scope => [:placement_id, :target_date],
  					  			     :case_sensitive => false,
  					  			     :message => " has already been entered." }
  validates	:target_date,		:presence		=> true
  validates	:note,			:length			=> { :maximum => 255, :allow_blank => true }

end
