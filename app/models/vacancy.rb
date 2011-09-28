# == Schema Information
#
# Table name: vacancies
#
#  id             :integer         not null, primary key
#  job_id         :integer
#  sector_id      :integer
#  annual_salary  :integer
#  hourly_rate    :decimal(5, 2)
#  voluntary      :boolean         default(FALSE)
#  filled         :boolean         default(FALSE)
#  notes          :string(255)
#  contact_person :string(255)
#  contact_email  :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

class Vacancy < ActiveRecord::Base

  attr_accessible :job_id, :sector_id, :annual_salary, :hourly_rate, :voluntary, :filled, :notes, :contact_person, :contact_email
  
  belongs_to :job
  belongs_to :sector
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :job_id, 	:presence	=> true
  validates :email, 	:format 	=> { :with => email_regex }
  
end
