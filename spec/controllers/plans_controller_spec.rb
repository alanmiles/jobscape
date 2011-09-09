require 'spec_helper'

describe PlansController do

  render_views
  
  before(:each) do
    @business = Factory(:business)
    @occupation = Factory(:occupation)
    @job = Factory(:job, :business_id => @business.id, :occupation_id => @occupation.id)
    @plan = Plan.find_by_job_id(@job)
    @job2 = Factory(:job, :business_id => @business.id, :occupation_id => @occupation.id,
    				:job_title => "Another job")
    @plan2 = Plan.find_by_job_id(@job2)
  end
  
  describe "GET 'show'" do
    it "should be successful" do
      get 'show', :id => @plan.id
      response.should be_success
    end
    
    it "should display the job and business name" do
      get 'show', :id => @plan.id
      response.should have_selector("h4", 
             	:content => "#{@job.job_title} - #{@business.name}, #{@business.city}")
    end
    
    it "should have a link back to the jobs 'show' page" do
      get 'show', :id => @plan.id
      response.should have_selector("a", :href => job_path(@job))
    end
    
    it "should have a link to 'responsibilities'" do
      get 'show', :id => @plan.id
      response.should have_selector("a", :href => plan_responsibilities_path(@plan))
    end
    
    it "should count the number of responsibilities entered" do
      @responsibility1 = Factory(:responsibility, :plan_id => @plan.id)
      @responsibility2 = Factory(:responsibility, :definition => "Responsibility 2",
                                 :plan_id => @plan.id)
      @removed_responsibility = Factory(:responsibility, :definition => "Responsibility 3",
                                 :plan_id => @plan.id, :removed => true)                         
      @diff_plan_responsibility = Factory(:responsibility, :definition => "Responsibility 4",
                                 :plan_id => @plan2.id)
      
      get 'show', :id => @plan.id
      response.should have_selector("span#responsibilities", :content => "2 entered")
    
    end
    
    it "should have a link to goals"
    
    it "should count the number of responsibilities with goals set"
    
    it "should have a link to personal attributes"
    
    it "should count the number of personal attributes set"
    
    it "should have a link to hiring requirements"
    
    it "should show whether or not hiring requirements have been completed"
    
    it "should have a link to the job summary"
    
    it "should indicate whether or not the summary has been written"
    
    it "should have a link to job evaluation"
    
    it "should indicate whether job evaluation is complete or not"
   
  end

end
