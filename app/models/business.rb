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
#  mission    :text
#  values     :text
#

class Business < ActiveRecord::Base

  attr_accessible :name, :address, :latitude, :longitude, :created_by, :sector_id, :mission, :values
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
  has_many :objectives, :dependent => :destroy
  has_many :reviews, :dependent => :destroy
  
  
  validates :sector_id, :presence 	=> true
  validates :name, 	:presence 	=> true,
  			:length		=> { :maximum => 50 },
  			:uniqueness 	=> { :scope => :address, 
  			         :message => "+ address appears to be a duplicate" }
  validates :address, 	:presence 	=> true,
  			:length		=> { :maximum => 50 }
  validates :mission,	:length		=> { :maximum => 500, :allow_blank => true }
  validates :values,	:length		=> { :maximum => 500, :allow_blank => true }
  			
  def no_jobs?
    self.jobs.count == 0
  end
  
  def no_departments?
    self.departments.count == 0
  end
  
  def no_vacancies?
    self.vacancies.count == 0
  end
  
  def no_associations?
    self.no_jobs? && self.no_vacancies?
    #MODIFY LATER TO ADD NO EMPLOYEES
  end
  
  def no_invitations?
    self.invitations.count == 0
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
  
  def all_current_employees_except(user)
    self.users.joins(:employees).where("employees.left = ? and users.id != ?", false, user.id).order("users.name")
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
  
  def officer_list
    self.employees.where("employees.officer = ? and employees.left = ?", true, false)
  end
  
  def needs_an_officer?
    nmbr = self.officer_list.count
    nmbr < 2
  end
  
  def next_ref_no
    @employee = self.employees.order("employees.ref_no DESC").first
    @employee.ref_no + 1
  end
  
  def available_jobs
    self.jobs.where("jobs.inactive = ?", false).order("jobs.job_title")
  end
  
  def inactive_jobs
    self.jobs.where("jobs.inactive = ?", true).order("jobs.job_title")
  end
  
  def current_departments
    self.departments.where("departments.hidden = ?", false).order("departments.name")
  end
  
  def hidden_departments
    self.departments.where("departments.hidden = ?", true).order("departments.name")
  end
  
  def objectives_by_focus(fcs)
    self.objectives.where("objectives.focus = ?", fcs)
  end
  
  def max_objectives_by_focus?(fcs)
    nmbr = self.objectives_by_focus(fcs).count
    nmbr >= 5   
  end
  
  def requiring_appraisal
    @no_appraisals = []
    @users = self.all_current_employees
    @users.each do |u|
      unless u.external_review_overdue?(self) #because external reviews take precedence
        if u.self_appraisal_overdue?(self)
          @no_appraisals << User.find(u.id)
        end
      end
    end
    @reqd = @no_appraisals
  end
  
  def requiring_review
    @no_reviews = []
    @users = self.all_current_employees
    @users.each do |u|
      if u.external_review_overdue?(self)
        @no_reviews << User.find(u.id)
      end
    end
    @reqd = @no_reviews
  end
  
  def reviews_in_progress
    self.reviews.where("reviews.completed = ? and reviews.cancel = ?", false, false)
  end
  
end
