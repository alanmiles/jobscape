# == Schema Information
#
# Table name: jobqualities
#
#  id         :integer         not null, primary key
#  plan_id    :integer
#  quality_id :integer
#  created_at :datetime
#  updated_at :datetime
#  position   :integer
#

require 'spec_helper'

describe Jobquality do

  before(:each) do
    @business = Factory(:business)
    @occupation = Factory(:occupation)
    @job = Factory(:job, :business_id => @business.id, 
    			:occupation_id => @occupation.id)  
    @job2 = Factory(:job, :job_title => "Another job", 
                          :business_id => @business.id,
                          :occupation_id => @occupation.id)
    @plan = Plan.find_by_job_id(@job.id)
    @plan2 = Plan.find_by_job_id(@job2.id) 
    @quality = Factory(:quality)
    @attr = { :quality_id => @quality.id }
  end

  it "should create a new instance given valid attributes" do
    @plan.jobqualities.create!(@attr)
  end
  
  it "should not have a missing quality_id" do
    @missing_quality = @plan.jobqualities.create(@attr.merge(:quality_id => nil))
    @missing_quality.should_not be_valid
  end

  #it "should not have a missing job_id" do
  #  @missing_job = Jobquality.create(@attr.merge(:plan_id => nil))
  #  @missing_job.should_not be_valid
  #end
  
  it "should not permit duplicate records" do
    @plan.jobqualities.create(@attr)
    @dup_jq = @plan.jobqualities.new(@attr)
    @dup_jq.should_not be_valid
  end
  
  it "should accept a duplicate quality_id with a different job" do
    @plan.jobqualities.create(@attr)
    @non_dup = @plan2.jobqualities.new(@attr)
    @non_dup.should be_valid
  end
end
