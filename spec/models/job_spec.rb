# == Schema Information
#
# Table name: jobs
#
#  id            :integer         not null, primary key
#  job_title     :string(255)
#  business_id   :integer
#  occupation_id :integer
#  created_at    :datetime
#  updated_at    :datetime
#  department_id :integer
#

require 'spec_helper'

describe Job do
  
  before(:each) do
    @business = Factory(:business)
    @department = Factory(:department, :business_id => @business.id)
    @occupation = Factory(:occupation)
    @attr = { :job_title => "Sales Manager",
              :department_id => @department.id,
              :occupation_id => @occupation.id }
  end
  
  it "should create a new instance given valid attributes" do
    @business.jobs.create!(@attr)
  end
  
  describe "business and occupation associations" do
    
    before(:each) do
      @job = @business.jobs.create(@attr)
    end
  
    it "should have a business attribute" do
      @job.should respond_to(:business)
    end
    
    it "should have the right associated business" do
      @job.business_id.should == @business.id
      @job.business.should == @business
    end
    
    it "should have an occupation attribute" do
      @job.should respond_to(:occupation)
    end
  
  end
  
  describe "plan associations" do

    before(:each) do
      @job = @business.jobs.create(@attr)
     # @plan = Factory(:plan, :job_id => @job.id)
    end

    it "should have a plan attribute" do
      @job.should respond_to(:plan)
    end
    
    it "should destroy the associated plan" do
      @job.destroy
      Plan.find_by_job_id(@job.id).should be_nil
    end
    
  end
  
  describe "validations" do
  
    it "should require a business id" do
      Job.new(@attr).should_not be_valid
    end
    
    it "should require an occupation id" do
      @job = @business.jobs.new(@attr.merge(:occupation_id => ""))
      @job.should_not be_valid
    end
    
    it "should require a job title" do
      @business.jobs.build(:job_title => "  ").should_not be_valid  
    end
    
    it "should reject a long job-title" do
      @business.jobs.build(:job_title => "a" * 51).should_not be_valid
    end
  end
  
end
