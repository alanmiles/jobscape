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
#

class Job < ActiveRecord::Base

  attr_accessible :job_title, :occupation_id, :vacancy
  
  after_create :build_plan
  after_create :build_outline
  
  belongs_to :business
  belongs_to :occupation
  has_one :plan, :dependent => :destroy
  has_one :outline, :dependent => :destroy
  has_many :vacancies, :dependent => :destroy
  
  validates :job_title, :presence 	=> true,
  			:length		=> { :maximum => 50 },
  			:uniqueness 	=> { :scope => :business_id, 
  			     		     :message => " already exists" }
  validates :business_id, :presence	=> true
  validates :occupation_id, :presence	=> true
  
  default_scope :order => 'jobs.job_title'			     		     

  def title_location
    "#{self.job_title} - #{self.business.name}, #{self.business.city}"
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
