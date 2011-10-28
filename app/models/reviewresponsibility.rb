# == Schema Information
#
# Table name: reviewresponsibilities
#
#  id                :integer         not null, primary key
#  review_id         :integer
#  responsibility_id :integer
#  position          :integer
#  rating_value      :integer
#  total_goals       :integer
#  achieved_goals    :integer         default(0)
#  achievement_score :float           default(0.0)
#  created_at        :datetime
#  updated_at        :datetime
#

class Reviewresponsibility < ActiveRecord::Base

  belongs_to :review
  belongs_to :responsibility
  has_many :reviewgoals, :dependent => :destroy
  
  accepts_nested_attributes_for :reviewgoals
  
  after_save :build_review_goals
  
  attr_accessible :responsibility_id, :position, :total_goals, :reviewgoals_attributes
  
  validates	:review_id,			:presence	=> true
  validates	:responsibility_id,		:presence 	=> true
  validates	:position,			:presence 	=> true,
  						:numericality	=> { :integer => true }
  validates	:rating_value,			:presence	=> true,
  						:numericality	=> { :integer => true }
  validates	:total_goals,			:presence	=> true,
  						:numericality	=> { :integer => true }
  validates	:achieved_goals,		:presence 	=> true,
  						:numericality	=> { :integer => true }
  validates	:achievement_score,		:presence	=> true,
  						:numericality	=> true

  def has_reviewgoals?
    cnt = self.reviewgoals.count
    cnt > 0
  end
  
  private
  
    def build_review_goals
      unless self.has_reviewgoals?
        @responsibility = Responsibility.find(self.responsibility_id)
        @goals = @responsibility.goals.where("goals.removed = ?", false)
        @goals.each do |g|
          @reviewgoal = self.reviewgoals.build
          @reviewgoal.goal_id = g.id
          @reviewgoal.save
        end
      end
    end  

end
