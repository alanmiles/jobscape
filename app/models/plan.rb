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
    count_responsibilities >= 10 && max_attributes && has_requirements? && goals_complete? && self.job.outline.complete?
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
    return tot.to_s
  end
  
  def goals_complete?
    responsibilities_with_goals == count_responsibilities
  end
  
  private
  
    def build_outline
      @outline = Outline.new(:plan_id => self.id)
      @outline.save
    end
end
