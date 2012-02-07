# == Schema Information
#
# Table name: goals
#
#  id                :integer         not null, primary key
#  responsibility_id :integer
#  objective         :string(255)
#  removed           :boolean         default(FALSE)
#  removal_date      :date
#  created_by        :integer
#  updated_by        :integer
#  created_at        :datetime
#  updated_at        :datetime
#

class Goal < ActiveRecord::Base

  attr_accessible :objective, :removed, :removal_date, :created_by
  
  belongs_to :responsibility
  has_many :reviewgoals
  
  validates	:responsibility_id,	:presence 	=> true
  validates	:objective,		:presence 	=> true,
                			:length		=> { :maximum => 140 }
  validates	:created_by,		:presence	=> true,
  					:numericality	=> { :integer => true }


  def used?
    cnt = self.reviewgoals.count
    cnt > 0
  end

end
