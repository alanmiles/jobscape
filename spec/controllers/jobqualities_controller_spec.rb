require 'spec_helper'

describe JobqualitiesController do

  render_views
  
  before(:each) do
    @business = Factory(:business)
    @department = Factory(:department, :business_id => @business.id)
    @occupation = Factory(:occupation)
    @job = Factory(:job, :business_id => @business.id, 
                   :department_id => @department.id, :occupation_id => @occupation.id)
    session[:jobid] = @job.id
    session[:biz] = @business.id
    @plan = Plan.find_by_job_id(@job.id)
    @quality = Factory(:quality)
    @qualities = [@quality]
    @jobquality = Factory(:jobquality, :plan_id => @plan.id, :quality_id => @quality.id)
    @jobqualities = [@jobquality]
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

      before(:each) do
        8.times do
          @new_quality = Factory(:quality, :quality => Factory.next(:quality))
          @new_jobquality = Factory(:jobquality, 
           			:plan_id => @plan.id, 
           			:quality_id => @new_quality.id)
          @qualities << @new_quality
          @jobqualities << @new_jobquality
        end
      end
            
      it "should be successful" do
        get :index, :plan_id => @plan.id
        response.should be_success
      end
      
      it "should have the right title" do
        get :index, :plan_id => @plan.id
        response.should have_selector("title", 
                        :content => "Attributes")
      end
      
      it "should refer to the job title and business" do
        get :index, :plan_id => @plan.id
        response.should have_selector("h1", 
           :content => @job.job_title)  
      end
        
      it "should have an 'add an attribute' link (if < 10 attributes)" do
        get :index, :plan_id => @plan.id
        response.should have_selector("a", :href => new_plan_jobquality_path(@plan))
      end
        
      it "should not allow more than 10 attributes to be added" do
        @quality_10 = Factory(:quality, :quality => "Tenth quality")
        @jobquality_10 = Factory(:jobquality, 
        			:plan_id => @plan.id, 
        			:quality_id => @quality_10.id)
        get :index, :plan_id => @plan.id
        response.should_not have_selector("a", :href => new_plan_jobquality_path(@plan))
      end
        
      it "should have a 'return to A-Plan menu' link" do
        get :index, :plan_id => @plan.id
        response.should have_selector("a", :href => plan_path(@plan))
      end
        
      it "should list all selected attributes for this job" do
        get :index, :plan_id => @plan.id
        @jobqualities[0..2].each do |jobquality|
          response.should have_selector("li", :content => jobquality.quality.quality)
        end
      end
      
      it "should not list attributes selected for another job" do
        @job_2 = Factory(:job, :business_id => @business.id,
        			:department_id => @department.id, 
        			:occupation_id => @occupation.id,
        			:job_title => "Something else")
    	@plan_2 = Plan.find_by_job_id(@job_2.id)
    	@quality_nonplan = Factory(:quality, :quality => "Wisdom")
        @qualities << @quality_nonplan
    	@jobquality_nonplan = Factory(:jobquality, 
    		:plan_id => @plan_2.id, :quality_id => @quality_nonplan.id)
    	@jobqualities << @jobquality_nonplan
      
        get :index, :plan_id => @plan.id
      	@jobqualities.each do |jobquality|
          response.should_not have_selector("li", :content => "Wisdom")
        end
      end
      
      it "should have a link to the 'show' page for each attribute" do
        get :index, :plan_id => @plan.id
        @jobqualities[0..2].each do |jobquality|
          response.should have_selector("a", :href => jobquality_path(jobquality))
        end
      end
      
      it "should have a 'remove' button for each attribute" do
        get :index, :plan_id => @plan.id
        @jobqualities[0..2].each do |jobquality|
          response.should have_selector("a", :title => "Remove #{jobquality.quality.quality}")
        end
      end
      
      it "should display the attributes in a sortable, draggable list"
    
      it "should display the most important attribute at the top of the list" 
    
      it "should display the least important attribute at the bottom of the list"   

    end
    
    
    describe "GET 'show'" do
    
      it "should be successful" do
        get :show, :id => @jobquality.id
        response.should be_success
      end
        
      it "should have the right title" do
        get :show, :id => @jobquality.id
        response.should have_selector("title", 
             :content => "Attribute + Grades")
      end
      
      it "should list the grades for the attribute" do
      	get :show, :id => @jobquality.id
      	@quality = Quality.find(@jobquality.quality_id)
      	@pams = @quality.pams
      	@pams.each do |pam|
      	  response.should have_selector("li", :content => "#{pam.descriptor}")
      	end
      end
      
      #no longer has reference to current job - applies to all jobs
      
      #it "should have a reference to the current job" do
      #  get :show, :id => @jobquality.id
      #  @job = Job.find(@jobquality.plan.job_id)
      #  response.should have_selector("span#job", :content => @job.job_title)
      #end
      
      it "should maybe allow the user to suggest new definitions"
      
      it "should link back to the list of attributes for the job" do
        get :show, :id => @jobquality.id
        response.should have_selector("a", :href => plan_jobqualities_path(@plan))
      end  
    
    end
    
    describe "GET 'new'" do
      
      describe "if there are already 10 attributes for the job" do
        
        before(:each) do
          9.times do
            @new_quality = Factory(:quality, :quality => Factory.next(:quality))
            @new_jobquality = Factory(:jobquality, 
           			:plan_id => @plan.id, 
           			:quality_id => @new_quality.id)
            @qualities << @new_quality
            @jobqualities << @new_jobquality
          end
        end
          
        it "should not be successful" do
          get :new, :plan_id => @plan.id
          response.should_not be_success
        end
        
        it "should redirect to the attributes list for the plan" do
          get :new, :plan_id => @plan.id
          response.should redirect_to plan_jobqualities_path(@plan)
        end
        
        it "should have an explanatory message" do
          get :new, :plan_id => @plan.id
          flash[:notice].should =~ /Sorry, you're only allowed 10 attributes/i
        end
 
      end
        
      describe "if there are fewer than 10 attributes for the job" do
        
        it "should be successful" do
          get :new, :plan_id => @plan.id
          response.should be_success
        end
        
        it "should have the right title" do
          get :new, :plan_id => @plan.id
          response.should have_selector("title", 
                    :content => "Select attribute")
        end
        
        it "should have a 'cancel' option" do
          get :new, :plan_id => @plan.id
          response.should have_selector("a", 
                  :href => plan_jobqualities_path(@plan))
        end
        
        it "should have a 'select' box" do
          get :new, :plan_id => @plan.id
            response.should have_selector("select", 
                  :name => "jobquality[quality_id]")
        end
        
        it "should have a 'confirm selection' button" do
          get :new, :plan_id => @plan.id
          response.should have_selector("input", 
                  :type => "submit", 
                  :value => "Confirm selection")
        end
        
        it "should have a link to new attribute suggestions" do
          get :new, :plan_id => @plan.id
          response.should have_selector("a", :href => new_submitted_quality_path)
        end
        
        describe "handling previously-selected attributes" do
        
          before(:each) do
            @not_used_quality_1 = Factory(:quality, :quality => "Not used 1")
            @not_used_quality_2 = Factory(:quality, :quality => "Not used 2")
            @qualities << [@not_used_quality_1, @not_used_quality_2]
            2.times do
              @new_quality = Factory(:quality, :quality => Factory.next(:quality))
              @new_jobquality = Factory(:jobquality, 
           			:plan_id => @plan.id, 
           			:quality_id => @new_quality.id)
              @qualities << @new_quality
              @jobqualities << @new_jobquality
            end
          end
        
          it "should not display already-taken qualities in 'select'"
          
           # UNSURE HOW TO TEST
           
          #  get :new, :plan_id => @plan.id
          #  response.should_not have_selector("option", 
          #        :content => @quality.quality)
          #end
          
          it "should display available qualities in 'select'"
            #get :new, :plan_id => @plan.id
            #response.should have_selector("option", 
            #      :content => @not_used_quality_1.quality)
          #end
        
          it "should have a list displaying already-taken qualities" do
            get :new, :plan_id => @plan.id
            response.should have_selector("li", 
                  :content => @quality.quality)  
          end
          
          it "should present already-selected qualities in position order"
          
        
          it "should not display qualities not taken in the list" do
            get :new, :plan_id => @plan.id
            response.should_not have_selector("li", 
                  :content => @not_used_quality_1.quality)
          end  
        end
      end
    end
    
    describe "POST 'create'" do
    
      describe "if there are already 10 attributes set for the job" do
        
        before(:each) do
          9.times do
            @new_quality = Factory(:quality, :quality => Factory.next(:quality))
            @new_jobquality = Factory(:jobquality, 
           			:plan_id => @plan.id, 
           			:quality_id => @new_quality.id)
            @qualities << @new_quality
            @jobqualities << @new_jobquality
          end
          @quality_11 = Factory(:quality, :quality => "Quality 11")
          @attr = { :quality_id => @quality_11.id }
        end
        
        it "should not create a responsibility" do
          lambda do
            post :create, :plan_id => @plan.id, :jobquality => @attr
          end.should_not change(Jobquality, :count)
        end

        it "should render the job's attribute list page" do
          post :create, :plan_id => @plan.id, :jobquality => @attr
          response.should redirect_to plan_jobqualities_path(@plan)
        end
        
        it "should explain why the record cannot be created" do
          post :create, :plan_id => @plan.id, :jobquality => @attr
          flash[:notice].should == "Sorry, you're only allowed 10 attributes"
        end
          
      end
      
      describe "if there are fewer than 10 attributes selected" do
      
        describe "failure" do
        
          before(:each) do
            @attr = { :quality_id => @quality }
            #Attempts to create a duplicate record
          end

          it "should not create an attribute" do
            lambda do
              post :create, :plan_id => @plan.id, :jobquality => @attr
            end.should_not change(Jobquality, :count)
          end

          it "should have the right title" do
            post :create, :plan_id => @plan.id, :jobquality => @attr
            response.should have_selector("title", 
                         :content => "Select attribute")
          end

          it "should render the 'new' page" do
            post :create, :plan_id => @plan.id, :jobquality => @attr
            response.should render_template('new')
          end
      
          it "should reset the @selected_qualities value"
          it "should reset the @qualities value"
          #use integration tests for both of the above
          
        end
      
        describe "success" do
      
          before(:each) do
            @new_quality = Factory(:quality, :quality => "New Quality")
            @attr = { :quality_id => @new_quality.id }
          end
        
          it "should create an attribute" do
            lambda do
              post :create, :plan_id => @plan.id, :jobquality => @attr
            end.should change(Jobquality, :count).by(1)
          end

          it "should redirect to the attribute list for the job" do
            post :create, :plan_id => @plan.id, :jobquality => @attr
            @jobquality = Jobquality.last
            response.should redirect_to plan_jobqualities_path(@plan)
          end
      
          it "should have a success message" do
            post :create, :plan_id => @plan.id, :jobquality => @attr
            flash[:success].should == "'#{@new_quality.quality}' added."
          end    
       
          it "should be connected to the correct plan" do
            post :create, :plan_id => @plan.id, :jobquality => @attr
            @jobquality = Jobquality.last
            @jobquality.plan_id.should == @plan.id
          end
          
          it "should assign the correct position number" do
            total = @plan.jobqualities.count
            post :create, :plan_id => @plan.id, :jobquality => @attr
            @jobquality = Jobquality.last
            @jobquality.position.should == total + 1
          end
          
          describe "when the job's 20th responsibility has been created" do
            
            before(:each) do
              8.times do
                @new_quality = Factory(:quality, :quality => Factory.next(:quality))
                @new_jobquality = Factory(:jobquality, 
           			:plan_id => @plan.id, 
           			:quality_id => @new_quality.id)
                @qualities << @new_quality
                @jobqualities << @new_jobquality
              end
            end
              
            it "should have a flash message explaining no more can be created" do  
              post :create, :plan_id => @plan.id, :jobquality => @attr
              flash[:notice].should =~ /You've now set all 10 attributes required/i   
            end
          end
      
        end
    
      end
    end
    
    describe "DELETE 'destroy'" do
    
      it "should destroy the jobquality" do
        lambda do
          delete :destroy, :id => @jobquality
        end.should change(Jobquality, :count).by(-1)
      end

      it "should redirect to the attributes list for the job" do
        delete :destroy, :id => @jobquality
        response.should redirect_to(plan_jobqualities_path(@plan))
      end
        
      it "should have a success message" do
        delete :destroy, :id => @jobquality
        flash[:success].should == "'#{@jobquality.quality.quality}' no longer listed for this job."
      end
    
    end
  end
  
end
