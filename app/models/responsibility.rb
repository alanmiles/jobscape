# == Schema Information
#
# Table name: responsibilities
#
#  id           :integer         not null, primary key
#  plan_id      :integer
#  definition   :string(255)
#  rating       :integer         default(0)
#  removed      :boolean         default(FALSE)
#  removal_date :date
#  created_by   :integer
#  updated_by   :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class Responsibility < ActiveRecord::Base

  attr_accessible :definition, :removed, :created_by, :rating
  
  belongs_to :plan
  
  validates	:plan_id,	:presence 	=> true
  validates	:definition,	:presence 	=> true,
                		:length		=> { :maximum => 140 },
  				:uniqueness	=> { :case_sensitive => false, :scope => :plan_id }
  validates	:created_by,	:presence	=> true,
  				:numericality	=> { :integer => true }
  validates     :rating,     	:presence 	=> true,
  				:numericality	=> { :integer => true, :allow_zero => true },
  				:inclusion	=> { :in => 0..100 }
  				
  def display_rating
    if self.rating == 0
      "n/a"
    else
      self.rating.to_s
    end 
  end
  
end
