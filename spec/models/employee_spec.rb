# == Schema Information
#
# Table name: employees
#
#  id          :integer         not null, primary key
#  user_id     :integer
#  business_id :integer
#  officer     :boolean         default(FALSE)
#  created_at  :datetime
#  updated_at  :datetime
#  ref         :integer
#  left        :boolean         default(FALSE)
#

require 'spec_helper'

describe Employee do
 
  before(:each) do
    @sector = Factory(:sector)
    @user = Factory(:user)
    @business = Factory(:business, :sector_id => @sector.id)
    @attr = { :user_id => @user.id, :business_id => @business.id, :ref => 1 }
  end
  
  it "should create a new instance given valid attributes" do
    Employee.create!(@attr)
  end
  
  it "should require a user_id" do
    no_user_employee = Employee.new(@attr.merge(:user_id => ""))
    no_user_employee.should_not be_valid
  end
  
  it "should require a business_id" do
    no_business_employee = Employee.new(@attr.merge(:business_id => ""))
    no_business_employee.should_not be_valid
  end
  
  it "should refuse to accept a duplicate record" do
    Employee.create!(@attr)
    dup_employee = Employee.new(@attr)
    dup_employee.should_not be_valid
  end 
  
  it "should allow one employee to belong to more than one business" do
  
  end
  
  it "should allow a single business to have many employees" do
  
  end
  
end
