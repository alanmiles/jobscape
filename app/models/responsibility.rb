# == Schema Information
#
# Table name: responsibilities
#
#  id           :integer         not null, primary key
#  plan_id      :integer
#  definition   :string(255)
#  rating       :integer         default(0)
#  removed      :boolean         default(FALSE)
#  removal_date :date
#  created_by   :integer
#  updated_by   :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class Responsibility < ActiveRecord::Base

  attr_accessible :definition, :removed, :created_by, :rating
  
  after_create :build_evaluation
  after_destroy :reset_job_value
  
  belongs_to :plan
  has_many :goals, :dependent => :destroy
  has_one :evaluation, :dependent => :destroy
  has_many :applicresponsibilities
  
  validates	:plan_id,	:presence 	=> true
  validates	:definition,	:presence 	=> true,
                		:length		=> { :maximum => 140 },
  				:uniqueness	=> { :case_sensitive => false, :scope => :plan_id }
  validates	:created_by,	:presence	=> true,
  				:numericality	=> { :integer => true }
  validates     :rating,     	:presence 	=> true,
  				:numericality	=> { :integer => true, :allow_zero => true },
  				:inclusion	=> { :in => 0..100 }
  				
  def display_rating
    if self.rating == 0
      "n/a"
    else
      self.rating.to_s
    end 
  end
  
  def show_rating
    if rating == 0
      "Not set"
    else
      rating
    end
  end
  
  def has_rating?
    rating > 0
  end
  
  def count_current_goals
    self.goals.count(:conditions => ["removed =?", false])
  end
  
  def has_goals?
    count_current_goals >= 1
  end
  
  def maximum_goals?
    count_current_goals >= 3
  end
  
  private
  
    def build_evaluation
      @evaluation = Evaluation.new(:responsibility_id => self.id)
      @evaluation.save
    end
    
    def reset_job_value      
      #@responsibility = Responsibility.find(self.responsibility_id)
      @plan = Plan.find(self.plan_id)
      if @plan.responsibilities_with_ratings >= 10
        @val_tt = @plan.top_ten_value
        @plan.update_attribute(:job_value, @val_tt) unless @val_tt == @plan.job_value
      else
        unless @plan.job_value == 0
          @plan.update_attribute(:job_value, 0)
        end
      end       
    end
end
