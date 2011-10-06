# == Schema Information
#
# Table name: responsibilities
#
#  id           :integer         not null, primary key
#  plan_id      :integer
#  definition   :string(255)
#  rating       :integer         default(0)
#  removed      :boolean         default(FALSE)
#  removal_date :date
#  created_by   :integer
#  updated_by   :integer
#  created_at   :datetime
#  updated_at   :datetime
#

require 'spec_helper'

describe Responsibility do
  
  before(:each) do
    @sector = Factory(:sector)
    @user = Factory(:user)
    @business = Factory(:business, :sector_id => @sector.id)
    @occupation = Factory(:occupation)
    @job = Factory(:job, 
              :occupation_id => @occupation.id,
              :business_id => @business.id )
    @plan = Plan.find_by_job_id(@job.id)
    @attr = { :plan_id => @plan.id, :definition => "Here's an example", 
    				    :created_by => @user.id,
    				    :rating => 24 }
  end
  
  it "should create a new instance given valid attributes" do
    @plan.responsibilities.create!(@attr)
  end
  
  describe "associations" do
  
    before(:each) do
      @responsibility = @plan.responsibilities.create(@attr)
    end
    
    it "should have a plan attribute" do
      @responsibility.should respond_to(:plan)
    end
  
    it "should be associated with the correct plan" do
      @responsibility.plan_id.should == @plan.id
      @responsibility.plan.should == @plan
    end
  end
  
  describe "validations" do
  
    it "should not accept an empty definition" do
      no_definition = @plan.responsibilities.new(@attr.merge(:definition => ""))
      no_definition.should_not be_valid
    end
    
    it "should not accept a long definition" do
      long_def = "a" * 141
      long_definition = @plan.responsibilities.new(@attr.merge(:definition => long_def))
      long_definition.should_not be_valid
    end
    
    it "should not accept a duplicate definition for the same plan" do
      @plan.responsibilities.create(@attr)
      dup_responsibility = @plan.responsibilities.new(@attr)
      dup_responsibility.should_not be_valid
    end
    
    it "can accept a duplicate definition for a different plan" do
      @job2 = Factory(:job, :job_title => "Another job",
              :occupation_id => @occupation.id,
              :business_id => @business.id )
      @plan2 = Plan.find_by_job_id(@job2.id)
      @attr2 = { :plan_id => @plan2.id, :definition => "Here's an example", 
                 :created_by => @user.id }
  
      @plan.responsibilities.create(@attr)
      diff_plan = @plan2.responsibilities.new(@attr2)
      diff_plan.should be_valid
    end
    
    it "should have a rating" do
      no_rating = @plan.responsibilities.create(@attr.merge(:rating => nil))
      no_rating.should_not be_valid
    end
    
    it "should not have a rating higher than 100" do
      high_rating = @plan.responsibilities.create(@attr.merge(:rating => 101))
      high_rating.should_not be_valid
    end
    
    it "should not have a rating less than 0" do
      low_rating = @plan.responsibilities.create(@attr.merge(:rating => -1))
      low_rating.should_not be_valid
    end
  end
  
end
