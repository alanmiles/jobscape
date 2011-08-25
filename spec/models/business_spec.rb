# == Schema Information
#
# Table name: businesses
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  address    :string(255)
#  city       :string(255)
#  country    :string(255)
#  latitude   :float
#  longitude  :float
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Business do
  before(:each) do
    @attr = { 
      :name => "Some Company", 
      :address => "CB1 3TJ"
    }
  end

  it "should create a new instance given valid attributes" do
    Business.create!(@attr)
  end
  
  it "should require a name" do
    no_name_business = Business.new(@attr.merge(:name => ""))
    no_name_business.should_not be_valid
  end
  
  it "should require an address" do
    no_address_business = Business.new(@attr.merge(:address => ""))
    no_address_business.should_not be_valid
  end
  
  it "should not accept a long name" do
    long_name = "a" * 51
    long_name_business = Business.new(@attr.merge(:name => long_name))
    long_name_business.should_not be_valid
  end
  
  it "should not accept a long address" do
    long_address = "a" * 51
    long_address_business = Business.new(@attr.merge(:address => long_address))
    long_address_business.should_not be_valid
  end
  
  it "should not accept a duplicate entry" do
    Business.create!(@attr)
    duplicate_business = Business.new(@attr)
    duplicate_business.should_not be_valid
  end
  
  it "should accept a duplicate name in a different location" do
    Business.create!(@attr)
    @new_attr = { :name => "Some business", :address => "TN9 1SP" }
    Business.create(@new_attr)
  end
  
  it "should accept the same address with a different name" do
    Business.create!(@attr)
    @new_attr = { :name => "Another business", :address => "CB1 3TJ" }
    Business.create(@new_attr)
  end
  
  it "should automatically fill the latitude and longitude fields" do
    @business = Business.create!(@attr)
    @business.reload
    @business.latitude.should_not be_nil
  end  
end
