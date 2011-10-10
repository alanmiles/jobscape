# == Schema Information
#
# Table name: references
#
#  id              :integer         not null, primary key
#  user_id         :integer
#  name            :string(255)
#  relationship    :integer         default(4)
#  role            :string(255)
#  location        :string(255)
#  address         :string(255)
#  phone           :string(255)
#  email           :string(255)
#  portrait_rating :integer         default(7)
#  created_at      :datetime
#  updated_at      :datetime
#

class Reference < ActiveRecord::Base

  attr_accessible :name, :relationship, :role, :location, :address, :phone, :email, :portrait_rating
  
  belongs_to :user
  
  RELATIONSHIP_TYPES = [
    ["Manager", 1],
    ["Teacher", 2],
    ["Trainer", 3],
    ["Colleague", 4],
    ["Friend", 5]
  ]
  
  RATING_TYPES = [
    ["Completely accurate", 1],
    ["Mostly accurate", 2],
    ["Some inaccuracies", 3],
    ["Mostly inaccurate", 4],
    ["Completely inaccurate", 5],
    ["I don't know this person well enough", 6],
    ["No response", 7]
  ]
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :user_id,		:presence 	=> true
  validates :name,		:presence 	=> true,
  				:length		=> { :maximum => 50 },
  				:uniqueness	=> { :scope => :user_id, :message => "is already in the list" }
  validates :relationship,	:presence 	=> true,
  				:inclusion	=> { :in => 1..5 }
  validates :email,		:presence 	=> true,
  				:format 	=> { :with => email_regex }
  validates :portrait_rating,	:inclusion	=> { :in => 1..7 }				
  				
  def what_relation
    if relationship == 1
      return "Manager"
    elsif relationship == 2
      return "Teacher"
    elsif relationship == 3
      return "Trainer"
    elsif relationship == 4
      return "Colleague"
    else
      return "Friend"
    end  
  end

end
