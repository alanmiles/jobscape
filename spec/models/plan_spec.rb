# == Schema Information
#
# Table name: plans
#
#  id                  :integer         not null, primary key
#  job_id              :integer
#  responsibilities    :boolean         default(FALSE)
#  goals               :boolean         default(FALSE)
#  personal_attributes :boolean         default(FALSE)
#  recruitment_factors :boolean         default(FALSE)
#  summary             :boolean         default(FALSE)
#  evaluation          :boolean         default(FALSE)
#  job_value           :integer
#  updated_by          :integer
#  created_at          :datetime
#  updated_at          :datetime
#  no_changes          :boolean         default(FALSE)
#

require 'spec_helper'

describe Plan do
  
  before(:each) do
    @business = Factory(:business)
    @department = Factory(:department, :business_id => @business.id)
    @occupation = Factory(:occupation)
    @job = Factory(:job, 
              :occupation_id => @occupation.id,
              :department_id => @department.id,
              :business_id => @business.id )
    @plan = Plan.find_by_job_id(@job.id)
    @attr = { :job_id => @job.id }
  end
  
  it "a new instance should be created automatically at job creation" do
   # @plan = Plan.find_by_job_id(@job.id)
    @plan.should_not be_nil
  end
  
  it "should not permit a second plan to be built for the same job" do
    duplicate_plan = Plan.new(@attr)
    duplicate_plan.should_not be_valid
  end
  
  it "should have a job attribute" do
    @plan.should respond_to(:job)
  end
  
  it "should be associated with the correct job" do
    @plan.job_id.should == @job.id
  end
end
