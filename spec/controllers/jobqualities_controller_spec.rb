require 'spec_helper'

describe JobqualitiesController do

  render_views
  
  before(:each) do
    @business = Factory(:business)
    @occupation = Factory(:occupation)
    @job = Factory(:job, :business_id => @business.id, :occupation_id => @occupation.id)
    session[:jobid] = @job.id
    @plan = Plan.find_by_job_id(@job.id)
    #@responsibility = Factory(:responsibility, :plan_id => @plan.id)
  end
  
  describe "for non-signed-in users" do
  
    describe "GET 'index'" do
      it "should not be successful" do
        get :index, :plan_id => @plan.id
        response.should_not be_success
      end
    end

    describe "GET 'new'" do
      it "should not be successful" do
        get :new, :plan_id => @plan.id
        response.should_not be_success
      end
    end
    
  end
  
  describe "for signed-in users" do
  
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end
    
    describe "GET 'index'" do
      
      it "should be successful" do
        get :index, :plan_id => @plan.id
        response.should be_success
      end
      
      it "should have the right title" do
        get :index, :plan_id => @plan.id
        response.should have_selector("title", 
                        :content => "Attributes: #{@job.job_title}")
      end
      
      it "should refer to the job title and business"
        
      it "should have an 'add an attribute' link (if < 10 attributes)" do
        get :index, :plan_id => @plan.id
        response.should have_selector("a", :href => new_plan_jobquality_path(@plan))
      end
        
      it "should not allow more than 10 attributes to be added"
      #  7.times do
      #    @jobqualities << Factory(:jobquality, :definition => Factory.next(:definition),
      #                                   :plan_id => @plan.id)
      #  end
      #  get :index, :plan_id => @plan.id
      #  response.should_not have_selector("a", :href => new_plan_jobquality_path(@plan))
      #  response.should have_selector("div.r-float", 
      #                                :content => "No more attributes can be added")
      #end
        
      it "should have a 'return to A-Plan menu' link" do
        get :index, :plan_id => @plan.id
        response.should have_selector("a", :href => plan_path(@plan))
      end
        
      it "should list all selected attributes for this job"
      #  get :index, :plan_id => @plan.id
      #  @jobqualities[0..2].each do |jobquality|
      #    response.should have_selector("td", :content => jobquality.quality.quality)
      #  end
      #end
        
      it "should have a link to the 'show' page for each attribute"
      #  get :index, :plan_id => @plan.id
      #  @jobqualities[0..2].each do |jobquality|
      #    response.should have_selector("a", :href = jobquality_path(jobquality))
      #  end
      #end
    end
    
    it "should have a 'remove' button for each attribute"
    
    it "should display the attributes in a sortable, draggable list"
    
    it "should display the most important attribute at the top of the list" 
    
    it "should display the least important attribute at the bottom of the list"   

    describe "GET 'new'" do
      
      describe "if there are already 10 attributes for the job" do
          
        it "should not be successful"
        #  @responsibilities = [@responsibility]
        #  19.times do
        #    @responsibilities << Factory(:responsibility, 
        #                                 :definition => Factory.next(:definition),
        #                                 :plan_id => @plan.id)
        #  end
        #  get :new, :plan_id => @plan.id
        #  response.should_not be_success
        #end
 
      end
        
      describe "if there are fewer than 10 attributes for the job" do
        
        it "should be successful" do
          get :new, :plan_id => @plan.id
          response.should be_success
        end
        
        it "should have the right title" do
          get :new, :plan_id => @plan.id
          response.should have_selector("title", 
                    :content => "New attribute: #{@job.job_title}")
        end
        
        it "should have a 'cancel' option" do
          get :new, :plan_id => @plan.id
          response.should have_selector("a", 
                  :href => plan_jobqualities_path(@plan),
       	          :content => "Cancel")
        end
        
        it "should have a 'select' box"
        #  get :new, :plan_id => @plan.id
        #  response.should have_selector("textarea", 
        #          :name => "responsibility[definition]")
        #end
        
        it "should have a 'confirm selection' button" do
          get :new, :plan_id => @plan.id
          response.should have_selector("input", 
                  :type => "submit", 
                  :value => "Confirm selection")
        end
      end
    end
    
  end
  
end
