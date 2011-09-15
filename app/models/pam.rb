# == Schema Information
#
# Table name: pams
#
#  id         :integer         not null, primary key
#  quality_id :integer
#  grade      :string(255)
#  descriptor :string(255)
#  updated_by :integer
#  approved   :boolean         default(FALSE)
#  created_at :datetime
#  updated_at :datetime
#

class Pam < ActiveRecord::Base

  belongs_to :quality
  
  attr_accessible :descriptor, :approved, :grade, :updated_by
  
  validates :quality_id,	:presence 	=> true
  validates :grade,		:presence	=> true,
  				:length 	=> { :maximum => 1 },
  				:inclusion	=> { :in => %w(A B C D E) },
  				:uniqueness 	=> { :scope => :quality_id }
  validates :descriptor,	:presence 	=> true,
  				:length		=> { :maximum => 140 },
  				:uniqueness	=> { :case_sensitive => false, 
  						     :scope => :quality_id }
  
end
