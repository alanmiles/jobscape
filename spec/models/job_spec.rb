# == Schema Information
#
# Table name: jobs
#
#  id            :integer         not null, primary key
#  job_title     :string(255)
#  business_id   :integer
#  occupation_id :integer
#  vacancy       :boolean         default(FALSE)
#  created_at    :datetime
#  updated_at    :datetime
#

require 'spec_helper'

describe Job do
  
  before(:each) do
    @business = Factory(:business)
    @occupation = Factory(:occupation)
    @attr = { :job_title => "Sales Manager",
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
