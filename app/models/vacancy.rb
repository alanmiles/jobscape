# == Schema Information
#
# Table name: vacancies
#
#  id             :integer         not null, primary key
#  job_id         :integer
#  sector_id      :integer
#  quantity       :integer         default(1)
#  annual_salary  :integer
#  hourly_rate    :decimal(5, 2)
#  full_time      :boolean         default(TRUE)
#  voluntary      :boolean         default(FALSE)
#  close_date     :date
#  filled         :boolean         default(FALSE)
#  notes          :string(255)
#  contact_person :string(255)
#  contact_email  :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

class Vacancy < ActiveRecord::Base

  attr_accessible :job_id, :sector_id, :quantity, :annual_salary, :hourly_rate, :full_time, :voluntary, :close_date, :filled, :notes, :contact_person
  
  belongs_to :job
  belongs_to :sector
  has_many :applications
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :job_id, 	:presence		=> true
  validates :sector_id, :presence		=> true
  validates :quantity,  :presence 		=> true,
            		:numericality		=> { :only_integer => true }
  validates :quantity,  :not_zero		=> true
  validates :close_date, :presence		=> true
  validates :voluntary, :voluntary_salary 	=> true, :if => :salary_set?
  validates :voluntary, :voluntary_check	=> true, :if => :no_salary_set?
  validates :annual_salary, :numericality	=> { :only_integer => true, :allow_nil => true } 
  validates :annual_salary, :salary_double	=> true, :if => :has_hourly_rate?
  validates :hourly_rate, :numericality		=> { :allow_nil => true }
  
  def self.sum_for(job)
   self.where("job_id = ? and filled = ?", job.id, false).sum(:quantity)
  end
  
  def self.zero_for?(job)
    self.sum_for(job) == 0
  end
  
  #def self.history_sum_for(job)
  #  self.where("job_id = ?", job.id)
  #end
  
  def salary_set?
    self.annual_salary != nil || self.hourly_rate != nil
  end 
  
   def no_salary_set?
    self.annual_salary.nil? && self.hourly_rate.nil?
  end 
  
  def has_hourly_rate?
    self.hourly_rate != nil
  end
  
  def self.latest
    self.where("close_date >= ? and filled = ?", Date.today, false).order("created_at DESC").limit(10)
  end
  
  def self.all_current
    self.where("close_date > ? and filled = ?", Date.today, false).order("created_at DESC")
  end
  
  def self.has_current?
    @current = self.where("close_date > ? and filled = ?", Date.today, false).count
    @current > 0
  end
  
  def all_completed_applications
    applications.where("next_action = ? and submitted = ?", 2, true)
  end
  
  def interest_from?(user)
    self.applications.where("user_id = ?", user.id).count > 0
  end
  
  def application_from(user)
    Application.where("vacancy_id = ? and user_id = ?", self.id, user.id).first
  end
  
  def headline
    @headline = "#{self.job.job_title} / #{self.sector.sector} / #{self.job.business.city}"
  end
  
  def remuneration
    if annual_salary == nil
      sprintf("%.2f", self.hourly_rate)
    else
      self.annual_salary
    end
  end
  
  def remuneration_rate
    if annual_salary == nil
      return "/hour"
    else
      return "/year"
    end
  end
end
