# == Schema Information
#
# Table name: occupations
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Occupation do
  
  before(:each) do
    @attr = { :name => "Human Resources" }
  end
  
  it "should create a new instance given valid attributes" do
    Occupation.create!(@attr)
  end
  
  it "should require a name" do
    no_name_occupation = Occupation.new(@attr.merge(:name => ""))
    no_name_occupation.should_not be_valid
  end
  
  it "should not have a long name" do
    @long_occupation = "a" * 31
    long_name_occupation = Occupation.new(@attr.merge(:name => @long_occupation))
    long_name_occupation.should_not be_valid
  end
end


