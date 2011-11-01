# == Schema Information
#
# Table name: reviewqualities
#
#  id             :integer         not null, primary key
#  review_id      :integer
#  quality_id     :integer
#  position       :integer
#  reviewer_score :integer         default(0)
#  adjusted_score :integer         default(0)
#  created_at     :datetime
#  updated_at     :datetime
#

class Reviewquality < ActiveRecord::Base

  belongs_to :review
  belongs_to :quality
  
  attr_accessible :quality_id, :position, :reviewer_score
  
  PAM_SCORES = [
    ["A", 4],
    ["B", 3],
    ["C", 2],
    ["D", 1],
    ["E", 0]
  ]
  
  validates	:review_id,		:presence	=> true
  validates	:quality_id,		:presence 	=> true
  validates	:position,		:presence	=> true,
  					:numericality	=> { :integer => true }
  validates	:reviewer_score,	:presence	=> true,
  					:numericality	=> { :integer => true }
  validates	:adjusted_score,	:presence	=> true,
  					:numericality	=> { :integer => true }
  
  def has_reviewpams?
    cnt = self.reviewpams.count
    cnt > 0
  end
  
  def reviewer_pam
    if reviewer_score == 4
      @grade = "A"
    elsif reviewer_score == 3
      @grade = "B"
    elsif reviewer_score == 2
      @grade = "C"
    elsif reviewer_score == 1
      @grade = "D"
    else
      @grade = "E"
    end
    @quality = Quality.find(self.quality_id)
    @pam = Pam.where("quality_id = ? and grade = ?", @quality.id, @grade).first  
  end
end
