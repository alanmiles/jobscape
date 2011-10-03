# == Schema Information
#
# Table name: plans
#
#  id                  :integer         not null, primary key
#  job_id              :integer
#  responsibilities    :boolean         default(FALSE)
#  goals               :boolean         default(FALSE)
#  personal_attributes :boolean         default(FALSE)
#  recruitment_factors :boolean         default(FALSE)
#  summary             :boolean         default(FALSE)
#  evaluation          :boolean         default(FALSE)
#  job_value           :integer
#  updated_by          :integer
#  created_at          :datetime
#  updated_at          :datetime
#

class Plan < ActiveRecord::Base

  #after_create :build_outline
  
  belongs_to :job
  
  has_many :responsibilities, :dependent => :destroy
  has_many :jobqualities, :dependent => :destroy
  has_many :requirements, :dependent => :destroy
  has_many :evaluations, :through => :responsibilities
  
  validates	:job_id,  	:presence 		=> true,
                                :uniqueness		=> true
                                
  
  def count_responsibilities
    self.responsibilities.count(:all, :conditions => ["responsibilities.removed = ?", false]) 
  end
  
  def has_responsibilities?
    count_responsibilities > 0
  end
  
  def max_responsibilities?
    count_responsibilities >= 20
  end
  
  def responsibilities_ready?
    count_responsibilities >= 10
  end
  
  def count_attributes
    self.jobqualities.count(:all)
  end
  
  def has_attributes?
    count_attributes > 0
  end
  
  def max_attributes?
    count_attributes >= 10
  end
  
  def attributes_available
    if jobqualities.count == 0
      Quality.official_list
    else
      Quality.official_list_excluding_taken(self.id)
    end
  end
  
  def count_requirements
    self.requirements.count(:all)
  end
  
  def has_requirements?
    count_requirements > 0
  end
  
  def max_requirements?
    count_requirements >= 10  
  end
  
  def complete?
    #correct during build
    count_responsibilities >= 10 && max_attributes? && has_requirements? && goals_complete? && self.job.outline.complete?
  end
  
  def responsibilities_with_goals
    tot = 0
    @responsibilities = Responsibility.find(:all, 
              :conditions => ["plan_id = ? and removed = ?", self.id, false])
    @responsibilities.each do |responsibility|
      if responsibility.has_goals?
        tot = tot + 1
      end
    end
    return tot
  end
  
  def goals_complete?
    responsibilities_with_goals == count_responsibilities
  end
  
  def responsibilities_with_ratings
    totl = 0
    @responsibilities = Responsibility.find(:all, 
              :conditions => ["plan_id = ? and removed = ?", self.id, false])
    @responsibilities.each do |responsibility|
      if responsibility.rating >0
        totl = totl + 1        
      end
    end
    return totl
  end
  
  def ratings_complete?
    responsibilities_with_ratings == count_responsibilities  
  end
  
  def outline_complete?
    @job = Job.find(self.job_id)
    @outline = Outline.find_by_job_id(@job.id)
    @outline.complete?
  end
  
  def top_ten_ratings
    self.responsibilities.order("responsibilities.rating DESC").limit(10)
  end
  
  def top_ten_value
    score = 0
    self.top_ten_ratings.each do |r|
      score = score + r.rating
    end
    return score
  end
  
  private
  
    def build_outline
      @outline = Outline.new(:plan_id => self.id)
      @outline.save
    end
end
