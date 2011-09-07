require 'spec_helper'

describe PlansController do

  render_views
  
  before(:each) do
    @business = Factory(:business)
    @occupation = Factory(:occupation)
    @job = Factory(:job, :business_id => @business.id, :occupation_id => @occupation.id)
    @plan = Plan.find_by_job_id(@job)
  end
  
  describe "GET 'show'" do
    it "should be successful" do
      get 'show', :id => @plan.id
      response.should be_success
    end
    
    it "should display the job and business name" do
      get 'show', :id => @plan.id
      response.should have_selector("h4", :content => "#{@job.job_title} - #{@business.name}, #{@business.city}")
    end
    
    it "should have a link back to the jobs 'show' page" do
      get 'show', :id => @plan.id
      response.should have_selector("a", :href => job_path(@job))
    end
    
    it "should have a link to 'responsibilities'"
    
    it "should count the number of responsibilities entered"
    
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
