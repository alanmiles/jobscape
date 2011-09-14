# == Schema Information
#
# Table name: qualities
#
#  id           :integer         not null, primary key
#  quality      :string(255)
#  approved     :boolean         default(FALSE)
#  created_by   :integer
#  updated_by   :integer
#  seen         :boolean         default(FALSE)
#  removed      :boolean         default(FALSE)
#  removal_date :date
#  created_at   :datetime
#  updated_at   :datetime
#

class Quality < ActiveRecord::Base

  attr_accessible :quality, :approved, :seen, :removed, :created_by
  
  after_create  :build_pams
  
  has_many :pams, :dependent => :destroy
  
  validates	:quality,	:presence 	=> true,
                		:length		=> { :maximum => 25 },
  				:uniqueness	=> { :case_sensitive => false }
  validates	:created_by,	:presence	=> true,
  				:numericality	=> { :integer => true }
  
  def self.official_list
    self.find(:all, :conditions => ["approved = ? and removed = ?", true, false])
  end
  
  def self.new_list
    self.find(:all, :conditions => ["approved = ? and removed = ? and seen = ?", false, false, false])
  end
  
  def self.new_submissions
    self.new_list.count
  end
  
  private
  
    def build_pams
      @qlt = Quality.last
      @content = "Descriptor for "
      @grades = ["A", "B", "C", "D", "E"]
      @grades.each do |grade|
        @qlt.pams.create(:grade => grade, 
                   :descriptor => "#{@content}" + grade.to_s)  
      end
    end
end
