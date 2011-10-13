# == Schema Information
#
# Table name: jobqualities
#
#  id         :integer         not null, primary key
#  plan_id    :integer
#  quality_id :integer
#  created_at :datetime
#  updated_at :datetime
#  position   :integer
#

class Jobquality < ActiveRecord::Base

  belongs_to :plan
  belongs_to :quality

  acts_as_list :scope => :plan
  
  attr_accessible :quality_id, :position
  
  validates	:plan_id,	:presence 	=> true
  validates	:quality_id,	:presence 	=> true,
  				:uniqueness	=> { :scope => :plan_id }
  				
  				
  def self.count_attribute(quality)
    @total = self.find_all_by_quality_id(quality).count
  end
  
  def self.attribute_used?(quality)
    self.count_attribute(quality) > 0
  end
  
  def quality_content
    quality.quality
  end
end
