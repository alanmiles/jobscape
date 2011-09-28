# == Schema Information
#
# Table name: sectors
#
#  id         :integer         not null, primary key
#  sector     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Sector < ActiveRecord::Base

  attr_accessible :sector
  
  has_many :businesses
  has_many :vacancies
  
  validates :sector, 	:presence	=> true,
  	    		:length		=> { :maximum => 25 },
  	    		:uniqueness 	=> { :case_sensitive => false } 

  def associated_businesses?
    self.businesses.count > 0
  end
  
  def associated_vacancies?
    self.vacancies.count > 0
  end
    
end
