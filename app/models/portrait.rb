# == Schema Information
#
# Table name: portraits
#
#  id            :integer         not null, primary key
#  user_id       :integer
#  worked_before :boolean         default(FALSE)
#  right_to_work :boolean         default(FALSE)
#  notes         :string(255)
#  public        :boolean         default(FALSE)
#  created_at    :datetime
#  updated_at    :datetime
#

class Portrait < ActiveRecord::Base

  attr_accessible :worked_before, :right_to_work, :notes, :public
  
  belongs_to :user
  
  validates :user_id,			:presence	=> true
  validates :notes,			:length		=> { :maximum => 200, :allow_blank => true }
  
  
end
