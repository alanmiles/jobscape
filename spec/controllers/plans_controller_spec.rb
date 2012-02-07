require 'spec_helper'

describe PlansController do

  render_views
  
  before(:each) do
    @sector = Factory(:sector)
    @business = Factory(:business, :sector_id => @sector.id)
    session[:biz] = @business.id
    
    @user = Factory(:user)
    @occupation = Factory(:occupation)
    @department = Factory(:department, :business_id => @business.id)
    @job = Factory(:job, :business_id => @business.id, :department_id => @department.id, :occupation_id => @occupation.id)
    @plan = Plan.find_by_job_id(@job)
    @job2 = Factory(:job, :business_id => @business.id, :occupation_id => @occupation.id,
    			:department_id => @department.id, :job_title => "Another job")
    @plan2 = Plan.find_by_job_id(@job2)
    test_sign_in(@user)
  end
  
  describe "GET 'show'" do
  
    before(:each) do
      @responsibility1 = Factory(:responsibility, :plan_id => @plan.id)
      @responsibility2 = Factory(:responsibility, :definition => "Responsibility 2",
                                 :plan_id => @plan.id) 
      @wrong_plan_responsibility = Factory(:responsibility, :plan_id => @plan2.id,
                                     :definition => "Wrong responsibility")   
      @removed_responsibility = Factory(:responsibility, :definition => "Responsibility 3",
                                 :plan_id => @plan.id, :removed => true) 
      @diff_plan_responsibility = Factory(:responsibility, 
      					  :definition => "Responsibility 4",
                                 	  :plan_id => @plan2.id)
      @goal = Factory(:goal, :responsibility_id => @responsibility1.id)
      @removed_goal = Factory(:goal, :objective => "Removed", 
      				     :responsibility_id => @responsibility1.id,
      				     :removed => true)
      @wrong_responsibility_goal = Factory(:goal, :objective => "Wrong responsibility goal",
      				      :responsibility_id => @wrong_plan_responsibility.id)
    end
    
    it "should be successful" do
      get 'show', :id => @plan.id
      response.should be_success
    end
    
    it "should display the job and business name" do
      get 'show', :id => @plan.id
      response.should have_selector("#jobtitle", 
             	:content => @job.job_title)
    end
    
    it "should have a link back to the jobs 'show' page" do
      get 'show', :id => @plan.id
      response.should have_selector("a", :href => my_job_path)
    end
    
    it "should have a link to 'all jobs' for the business"
    #  response.should have_selector("a", :href => business_jobs_path(@business))
    #end
    #SEPARATE TESTS NEEDED FOR BUSINESS AS OPPOSED TO INDIVIDUAL USER
    
    #changed routing on return button
    
    #it "should have a link to 'responsibilities'" do
    #  get 'show', :id => @plan.id
    #  response.should have_selector("a", :href => plan_responsibilities_path(@plan))
    #end
    
    it "should count the number of responsibilities entered" do
      get 'show', :id => @plan.id
      response.should have_selector(".texthl", :content => "At least 8 more responsibilities needed")
    end

    #change to structure - now only shows a warning for unset goals if at least 10 responsibilities added
    
    #it "should count the number of responsibilities with goals set" do
    #  get 'show', :id => @plan.id
    #  response.should have_selector("span#goals", :content => "1 / 2")
    #end
    
    describe "personal attributes" do
      
      before (:each) do
        @quality = Factory(:quality)
        @jobquality = Factory(:jobquality, :quality_id => @quality.id,
                                  :plan_id => @plan.id)
      end
      
      it "should have a link to personal attributes" do
        get 'show', :id => @plan.id
        response.should have_selector("a", :href => plan_jobqualities_path(@plan))
      end
    
      it "should count the number of personal attributes set" do
        get 'show', :id => @plan.id
        response.should have_selector(".texthl", :content => "9 more attributes needed")
      end
    
    end    

    describe "hiring requirements" do
    
      it "should have a link to hiring requirements"
    
      it "should show whether or not hiring requirements have been completed"
    
    end
    
    describe "job summary" do
    
      it "should have a link to the job summary"
    
      it "should indicate whether or not the summary has been written"

    end
        
    describe "job evaluation" do
    
      it "should have a link to job evaluation"
    
      it "should indicate whether job evaluation is complete or not"
   
    end
  end

end
