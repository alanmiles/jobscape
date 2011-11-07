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
#  sector_id  :integer
#

class Business < ActiveRecord::Base

  attr_accessible :name, :address, :latitude, :longitude, :created_by, :sector_id
  geocoded_by :address
  reverse_geocoded_by :latitude, :longitude do |obj, results|
    if geo = results.first
      obj.city = geo.city
      obj.country = geo.country
    end
  end
  
  after_validation :geocode, :if => :address_changed?
  after_validation :reverse_geocode, :if => :address_changed?

  belongs_to :sector
  has_many :employees, 	:dependent => :destroy
  has_many :departments, :dependent => :destroy 
  has_many :jobs, 	:dependent => :destroy
  has_many :vacancies,  :through => :jobs
  has_many :users, :through => :employees, :uniq => true
  has_many :invitations, :dependent => :destroy
  
  
  validates :sector_id, :presence 	=> true
  validates :name, 	:presence 	=> true,
  			:length		=> { :maximum => 50 },
  			:uniqueness 	=> { :scope => :address, 
  			         :message => "+ address appears to be a duplicate" }
  validates :address, 	:presence 	=> true,
  			:length		=> { :maximum => 50 }
  			
  def no_jobs?
    self.jobs.count == 0
  end
  
  def no_vacancies?
    self.vacancies.count == 0
  end
  
  def no_associations?
    self.no_jobs? && self.no_vacancies?
    #MODIFY LATER TO ADD NO EMPLOYEES
  end
  
  def remove_disconnected_jobs
    if self.jobs.count > 0
      self.jobs.each do |job|
        @placement = Placement.find_by_job_id(job.id)
        if @placement == nil
          job.destroy
        end
      end
    end
  end
  
  def all_current_employees
    self.users.joins(:employees).where("employees.left = ?", false).order("users.name")
  end		
  
  def all_former_employees
    self.users.joins(:employees).where("employees.left = ?", true).order("users.name")
  end
  
  def count_current_employees
    self.all_current_employees.count
  end
  
  def count_former_employees
    self.all_former_employees.count
  end
  
  def has_former_employees?
    cnt = self.count_former_employees
    cnt > 0
  end
  	
  def needs_an_officer?
    nmbr = self.employees.where("employees.officer = ? and employees.left = ?", true, false).count
    nmbr < 2
  end
  
end
