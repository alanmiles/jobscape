class Occupation < ActiveRecord::Base

  attr_accessible :name
  
  has_many 	:jobs
  
  validates 	:name, 	:presence 	=> true,
  			:length		=> { :maximum => 30 }

  default_scope :order => 'occupations.name'
  
  def associated_jobs?
    self.jobs.count > 0
  end
  
end

# == Schema Information
#
# Table name: occupations
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

