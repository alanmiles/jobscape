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

require 'spec_helper'

describe Quality do
  
  before(:each) do
    @sector = Factory(:sector)
    @user = Factory(:user)
    @attr = { :quality => "Quality", :created_by => @user.id }
  end
  
  it "should create a new instance given valid attributes" do
    Quality.create!(@attr)
  end
  
  it "should not have a missing quality" do
    @empty_quality = Quality.create(@attr.merge(:quality => ""))
    @empty_quality.should_not be_valid
  end
  
  it "should not have a long quality" do
    long_name = "a" * 26
    long_name_quality = Quality.create(@attr.merge(:quality => long_name))
    long_name_quality.should_not be_valid
  end
  
  it "should not have a duplicate quality" do
    Quality.create(@attr)
    dup_quality = Quality.new(@attr)
    dup_quality.should_not be_valid
  end
  
  it "should not have a missing 'created_by'" do
    missing_creator = Quality.create(@attr.merge(:created_by => nil))
    missing_creator.should_not be_valid
  end
  
end
