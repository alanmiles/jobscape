# == Schema Information
#
# Table name: goals
#
#  id                :integer         not null, primary key
#  responsibility_id :integer
#  objective         :string(255)
#  removed           :boolean         default(FALSE)
#  removal_date      :date
#  created_by        :integer
#  updated_by        :integer
#  created_at        :datetime
#  updated_at        :datetime
#

require 'spec_helper'

describe Goal do
  
  before(:each) do
    @user = Factory(:user)
    @business = Factory(:business)
    @occupation = Factory(:occupation)
    @job = Factory(:job, 
              :occupation_id => @occupation.id,
              :business_id => @business.id )
    @plan = Plan.find_by_job_id(@job.id)
    @responsibility = Factory(:responsibility, :plan_id => @plan.id)
    @attr = { :responsibility_id => @responsibility.id, :objective => "Goal 1", 
    				    :created_by => @user.id }
  end
  
  
  it "should create a new instance given valid attributes" do
    @responsibility.goals.create!(@attr)
  end
  
  describe "associations" do
  
    before(:each) do
      @goal = @responsibility.goals.create(@attr)
    end
    
    it "should have a plan attribute" do
      @goal.should respond_to(:responsibility)
    end
  
    it "should be associated with the correct plan" do
      @goal.responsibility_id.should == @responsibility.id
      @goal.responsibility.should == @responsibility
    end
  end
  
  describe "validations" do
  
     it "should not accept an empty objective" do
      no_objective = @responsibility.goals.new(@attr.merge(:objective => ""))
      no_objective.should_not be_valid
    end
    
    it "should not accept a long objective" do
      long_obj = "a" * 141
      long_objective = @responsibility.goals.new(@attr.merge(:objective => long_obj))
      long_objective.should_not be_valid
    end
    
    it "should not accept a duplicate objective for the same responsibility" do
      @responsibility.goals.create(@attr)
      dup_objective = @responsibility.goals.new(@attr)
      dup_objective.should_not be_valid
    end
    
    it "can accept a duplicate objective for a different responsibility" do
      @responsibility2 = Factory(:responsibility, :plan_id => @plan.id,
                                 :definition => "Responsibility 2")
      @responsibility.goals.create(@attr)
      diff_responsibility = @responsibility2.goals.new(@attr)
      diff_responsibility.should be_valid
    end
  
  end
  
end
