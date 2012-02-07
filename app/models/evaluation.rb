# == Schema Information
#
# Table name: evaluations
#
#  id                :integer         not null, primary key
#  responsibility_id :integer
#  profits           :integer         default(0)
#  customers         :integer         default(0)
#  staff             :integer         default(0)
#  processes         :integer         default(0)
#  created_at        :datetime
#  updated_at        :datetime
#

class Evaluation < ActiveRecord::Base

  attr_accessible :profits, :customers, :staff, :processes, :responsibility_id

  after_save :reset_rating
  after_save :reset_job_rating
  
  RATING_TYPES = [
    ["No impact", 0],
    ["Marginal", 2],
    ["Useful", 5],
    ["Important", 8],
    ["Critical", 10]
  ]
  
  belongs_to :responsibility
  
  validates 	:responsibility_id,	:presence 	=> true
  validates	:profits,		:presence 	=> true
  			
  validates	:customers,		:presence 	=> true
  					#:inclusion	=> { :in => self::RATING_TYPES }
  					 		
  validates	:staff,			:presence 	=> true
  					#:inclusion	=> { :in => self::RATING_TYPES }
  		
  validates	:processes,		:presence 	=> true
  					#:inclusion	=> { :in => self::RATING_TYPES }
  	
  
  
  private
  
    def reset_rating
      @responsibility = Responsibility.find(self.responsibility_id)
      value = ((profits * 5) + (customers * 5) + (staff * 5) + (processes * 5)) / 2
      @responsibility.update_attribute(:rating, value)
    end	
    
    def reset_job_rating
      @responsibility = Responsibility.find(self.responsibility_id)
      @plan = Plan.find(@responsibility.plan_id)
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
