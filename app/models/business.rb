# == Schema Information
#
# Table name: businesses
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  address    :string(255)
#  city       :string(255)
#  country    :string(255)
#  latitude   :float
#  longitude  :float
#  created_at :datetime
#  updated_at :datetime
#

class Business < ActiveRecord::Base

  attr_accessible :name, :address, :latitude, :longitude, :created_by
  geocoded_by :address
  reverse_geocoded_by :latitude, :longitude do |obj, results|
    if geo = results.first
      obj.city = geo.city
      obj.country = geo.country
    end
  end
  after_validation :geocode, :if => :address_changed?
  after_validation :reverse_geocode, :if => :address_changed?

  has_many :employees
  
  validates :name, 	:presence 	=> true,
  			:length		=> { :maximum => 50 },
  			:uniqueness 	=> { :scope => :address, 
  			         :message => "+ address appears to be a duplicate" }
  validates :address, 	:presence 	=> true,
  			:length		=> { :maximum => 50 }
  		
end
