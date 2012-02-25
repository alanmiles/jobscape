# == Schema Information
#
# Table name: jobs
#
#  id            :integer         not null, primary key
#  job_title     :string(255)
#  business_id   :integer
#  occupation_id :integer
#  created_at    :datetime
#  updated_at    :datetime
#  department_id :integer
#  inactive      :boolean         default(FALSE)
#

class Job < ActiveRecord::Base

  attr_accessible :job_title, :occupation_id, :vacancy, :department_id, :inactive
  
  after_create :build_plan
  after_create :build_outline
  
  belongs_to :business
  belongs_to :occupation
  belongs_to :department
  has_one :plan, :dependent => :destroy
  has_one :outline, :dependent => :destroy
  has_many :vacancies, :dependent => :destroy
  has_many :applications, :through => :vacancies
  has_many :placements, :dependent => :destroy
  has_many :users, :through => :placements, :uniq => true
  has_many :jobqualities, :through => :plan
  has_many :responsibilities, :through => :plan
  has_many :reviews
  has_many :invitations, :dependent => :destroy
  
  validates :job_title, :presence 	=> true,
  			:length		=> { :maximum => 30 },
  			:uniqueness 	=> { :scope => :department_id, 
  			     		     :message => " already exists in this department" }
  validates :business_id, :presence	=> true
  validates :occupation_id, :presence	=> true
  validates :department_id, :presence	=> true
  
  default_scope :order => 'jobs.job_title'			     		     

  def title_location
    "#{self.job_title} - #{self.business.name}, #{self.business.city}"
  end
  
  def title_department
    if self.department.name == "Unknown"
      "#{self.job_title}"
    else
      "#{self.job_title}, #{self.department.name}"
    end
  end
  
  def unfilled_vacancies
    self.vacancies.where("vacancies.filled = ?", false)
  end
  
  def vacancy_record_count
    self.unfilled_vacancies.count
  end
  
  def has_vacancies?
    vacancy_record_count > 0
  end
  
  def active_placements
    self.placements.where("placements.current = ?", true)
  end
  
  def has_active_placements?
    self.active_placements.count > 0
  end
  
  def active_users
    self.users.joins(:placements).where("placements.current = ?", true).order("users.name")
  end
  
  def former_placements
    self.placements.where("placements.current =?", false)
  end
  
  def has_former_placements?
    self.former_placements.count > 0
  end
  
  def self.inactive_discovered?(dept_id, title)
    @cnt = self.where("department_id = ? and job_title = ? and inactive = ?", dept_id, title, true).count
    @cnt > 0
  end
  
  private
  
    def build_plan
      @plan = Plan.new(:job_id => self.id)
      @plan.save 
    end
    
    def build_outline
      @outline = Outline.new(:job_id => self.id)
      @outline.save
    end
    
end
