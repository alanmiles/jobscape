require 'spec_helper'

describe JobsController do

  render_views
  
  before(:each) do
    @sector = Factory(:sector)
    @business = Factory(:business, :sector_id => @sector.id)
    @department = Factory(:department, :business_id => @business.id)
    session[:biz] = @business.id
  end

  describe "for non-signed-in users" do
  
    describe "GET 'index'" do
      it "should not be successful" do
        get :index, :business_id => @business.id
        response.should_not be_success
      end
    end

    describe "GET 'new'" do
      it "should not be successful" do
        get :new, :business_id => @business.id
        response.should_not be_success
      end
    end
    
    describe "POST 'create'" do
    
      before(:each) do
        @occupation = Factory(:occupation)
        @title = "Sales Assistant"
        @attr = { :job_title => @title, :occupation_id => @occupation.id }
      end
        
      it "should not create a job" do
        lambda do
          post :create, :business_id => @business.id, :job => @attr
        end.should_not change(Job, :count)
      end
      
      it "should deny access to 'create'" do
        post :create, :business_id => @business.id, :job => @attr
        response.should redirect_to(signin_path)
      end
    end
    
    describe "GET 'show'" do
    
      before(:each) do
        @occupation = Factory(:occupation)
        @job = Factory(:job, :business_id => @business.id, 
                  :department_id => @department.id, :occupation_id => @occupation.id)
      end
     
      it "should not be successful" do
        get :show, :id => @job
        response.should_not be_success
      end
      
    end
    
    describe "GET 'edit'" do
    
      before(:each) do
        @occupation = Factory(:occupation)
        @job = Factory(:job, :business_id => @business.id, 
                      :department_id => @department.id, :occupation_id => @occupation.id)
      end
      
      it "should not be successful" do
        get :edit, :id => @job
        response.should_not be_success
      end
      
    end
    
    describe "PUT 'update'" do
    
      before(:each) do
        @occupation = Factory(:occupation)
        @job = Factory(:job, :business_id => @business.id, 
                       :department_id => @department.id, :occupation_id => @occupation.id)
        @attr = { :job_title => "Another job" }
      end
      
      it "should not permit job updates" do
        put :update, :id => @job, :job => @attr
        response.should redirect_to signin_path
      end
      
      it "should not change the job's attributes" do
        put :update, :id => @job, :job => @attr
        @job.reload
        @job.job_title.should_not  == "Another job"
      end
    end
    
    describe "DELETE 'destroy'" do
    
      before(:each) do
        @occupation = Factory(:occupation)
        @job = Factory(:job, :business_id => @business.id, 
                      :department_id => @department.id, :occupation_id => @occupation.id)
        
      end
      
      it "should not destroy the job" do
        lambda do
          delete :destroy, :id => @job
        end.should_not change(Job, :count)
      end
      
      it "should redirect to the signin page" do
        delete :destroy, :id => @job
        response.should redirect_to signin_path
      end
    end
    
  end
  
  describe "for signed-in admins" do
  
    before(:each) do
      @user = Factory(:user, :admin => true)
      test_sign_in(@user)
    end
  
  end
  
  describe "for signed-in officers who belong to the current business" do
   
    before(:each) do
      @user = Factory(:user)
      @employee = Factory(:employee, :user_id => @user.id,
      				:business_id => @business.id)
      @occupation = Factory(:occupation)
      @job = Factory(:job, :business_id => @business.id, :department_id => @department.id, :occupation_id => @occupation.id)
      @plan = Plan.find_by_job_id(@job.id)
      test_sign_in(@user)
        
    end
    
    describe "GET 'index'" do
      
      before(:each) do
        @job2 = Factory(:job, :job_title => "Merchandiser", :occupation_id => @occupation.id,
        					:department_id => @department.id, :business_id => @business.id)
        @job3 = Factory(:job, :job_title => "Sales Assistant", :occupation_id => @occupation.id,
        					:department_id => @department.id, :business_id => @business.id)
        @jobs = [@job, @job2, @job3]						    
      end
      
      it "should be successful" do 
        get :index, :business_id => @business.id
        response.should be_success
      end
      
      it "should have the right title" do
        get :index, :business_id => @business.id
        response.should have_selector("title",
          	:content => "Jobs")
      end
      
      it "should display each of the jobs" do
        get :index, :business_id => @business.id
        @jobs.each do |job|
          response.should have_selector("li", :content => job.job_title)
        end
      end
      
      it "should not display jobs from another business" do
        @business2 = Factory(:business, :name => "Not Cambiz", :sector_id => @sector.id)
        @department2 = Factory(:department, :business_id => @business2.id, :name => "Admin")
        @employee2 = Factory(:employee, :user_id => @user.id, :business_id => @business2.id, :ref_no => 2)
        @job_99 = Factory(:job, :job_title => "Another job", :business_id => @business2.id,
                                               :department_id => @department2.id, :occupation_id => @occupation.id)
        @jobs << @job_99
        get :index, :business_id => @business.id
        response.should_not have_selector("td", :content => @job_99.job_title)
      end
      
      it "should have a link to the jobs 'show' page" do
        get :index, :business_id => @business.id
        @jobs.each do |job|
          response.should have_selector("a", :href => job_path(job))
        end
      end
      
      it "should display the job category" do
        get :index, :business_id => @business.id
        @jobs.each do |job|
          response.should have_selector("li", :content => job.occupation.name)
        end
      end
      
      it "should display the department"
      
      it "should show how many employees in the job"
      
      it "should show whether there's an A-plan"
      
      it "should have a delete button if no A-plan/employees in job"
      
      it "should not have a delete button if A-plan / employees in job"
      
      it "should have an 'Add new job' link" do
        get :index, :business_id => @business.id
        response.should have_selector("a", :href => new_business_job_path(@business))
      end
      
   
      it "should paginate long lists of jobs" do
        30.times do
          @jobs << Factory(:job, :job_title => Factory.next(:job_title), 
                                 :business_id => @business.id,
                                 :department_id => @department.id,
                                 :occupation_id => @occupation.id)
        end	
        get :index, :business_id => @business.id
        response.should have_selector("div.pagination")
        response.should have_selector("span.disabled", :content => "Previous")
        response.should have_selector("a", :href => "/businesses/#{@business.id}/jobs?page=2",
                                           :content => "2")
        response.should have_selector("a", :href => "/businesses/#{@business.id}/jobs?page=2",
                                           :content => "Next")
      end
      
    end

    describe "GET 'show'" do
    
      it "should be successful" do
        get :show, :id => @job
        response.should be_success
      end
      
      it "should have the right title" do
        get :show, :id => @job
        response.should have_selector("title", :content => "Job details")
      end
      
      it "should include the business name" do
        get :show, :id => @job
        response.should have_selector("h4", :content => @job.business.name_city)
      end
      
      it "should include the job category" do
        get :show, :id => @job
        response.should have_selector(".subtext", :content => @job.occupation.name)
      end
      
      it "should include the department"
      
      it "should have a link to the 'edit' form" do
        get :show, :id => @job
        response.should have_selector("a", :href => edit_job_path(@job))
      end
      
      it "should have a link to the jobs list for the business" do
        get :show, :id => @job
        response.should have_selector("a", :href => business_jobs_path(@business))
      end
      
      it "should display the number of vacancies"
      
      it "should have an 'adjust vacancies' button"
      
      it "should have a link to the A-Plan" do
        #@plan = Plan.find_by_job_id(@job)
        get :show, :id => @job
        response.should have_selector("a", :href => plan_path(@plan))
      end
      
      describe "A-Plan status" do
      
        describe "when the A-Plan has not been started" do
          
          it "should state that there's no A-Plan" do
            get :show, :id => @job
            response.should have_selector("span#status", :content => "Create one now")
          end
          
        end
        
      	describe "when the A-Plan is incomplete" do
          
          it "should show that the A-Plan needs more work" do
            @responsibility = Factory(:responsibility, :plan_id => @plan.id)
            get :show, :id => @job
            response.should have_selector("span#status", 
                          :content => "Incomplete - continue building")
          end
        
      	end
      
        describe "when the job has a completed A-Plan" do
      
          it "should show that the A-Plan is useable"
            #@responsibility = Factory(:responsibility, :plan_id => @plan.id)
            #@responsibility2 = Factory(:responsibility, 
            #		:definition => "Responsibility 2", :plan_id => @plan.id)
            #get :show, :id => @job
            #response.should have_selector("span#status", 
            #              :content => "Complete - view/edit?")
          #end
          #UPDATE TO INCLUDE ALL REQUIRED FACTORSerwqg
        end
      
      end
      
      describe "when the job has attached employees" do
      
        it "should list the employees"
        
        it "should have a link to the employee page"
        
        it "should have an 'add employee' option"
      end
      
      describe "when the job has no employees" do
      
        it "should say there are no employees"
        
        it "should have an 'add employee' option"
        
      end
    end  
    
    describe "GET 'new'" do
      it "should be successful" do
        get :new, :business_id => @business.id
        response.should be_success
      end
      
      it "should have the right title" do
        get :new, :business_id => @business.id
        response.should have_selector("title", 
                            :content => "New job")
      end
        
      it "should be the right business" do
        get :new, :business_id => @business.id
        @business.id.should == @employee.business_id
      end
      
    end
  
    describe "when no business has been selected" do
    
      before(:each) do
        session[:biz] = nil
      end
      
      describe "GET 'index'" do
        it "should not be successful" do
          get :index, :business_id => @business.id
          response.should_not be_success
        end
      end
       
      describe "GET 'new'" do
        it "should not be successful" do
          get :new, :business_id => @business.id
          response.should_not be_success
        end 
         
      end
    end
  
    describe "POST 'create'" do
    
      describe "failure" do
      
        before(:each) do
          @title = ""
          @attr = { :job_title => @title, :occupation_id => @occupation.id, :department_id => @department.id }
        end

        it "should not create a job" do
          lambda do
            post :create, :business_id => @business.id, :job => @attr
          end.should_not change(Job, :count)
        end

        it "should have the right title" do
          post :create, :business_id => @business.id, :job => @attr
          response.should have_selector("title", :content => "New job")
        end

        it "should render the 'new' page" do
          post :create, :business_id => @business.id, :job => @attr
          response.should render_template('new')
        end
      
      end
      
      describe "success" do
       
        before(:each) do
          @title = "Sales Assistant"
          @attr = { :job_title => @title, :occupation_id => @occupation.id, :department_id => @department.id }
        end
        
        it "should create a job" do
          lambda do
            post :create, :business_id => @business.id, :job => @attr
          end.should change(Job, :count).by(1)
        end

        it "should redirect to the jobs list" do
          post :create, :business_id => @business.id, :job => @attr
          response.should redirect_to my_job_path
          #ADD A DIFFERENT ROUTE FOR BUSINESS USERS
        end
      
        it "should have a success message" do
          post :create, :business_id => @business.id, :job => @attr
          flash[:success].should == @title + " added."
        end    
       
        it "should create an associated achievement plan" do
          post :create, :business_id => @business.id, :job => @attr
          @job = Job.last
          @plan = Plan.find_by_job_id(@job.id)
          @plan.should_not be_nil
        end
       
      end
    end
    
    describe "GET 'edit'" do
    
      it "should be successful" do
        get :edit, :id => @job
        response.should be_success
      end
      
      it "should have the right title" do
        get :edit, :id => @job
        response.should have_selector("title", :content => "Edit job")
      end
      
      it "should have a 'change' button" do
        get :edit, :id => @job
        response.should have_selector("input", :type => "submit", :value => "Update Job")
      end
      
      it "should have a 'cancel' button" do
        get :edit, :id => @job
        response.should have_selector("a", :href => business_jobs_path(@business))
      end
    end
    
    describe "PUT 'update'" do
    
      describe "failure" do
        
        before(:each) do
          @attr = { :job_title => ""}
        end
        
        it "should render the 'edit' page" do
          put :update, :id => @job, :job => @attr
          response.should render_template('edit')
        end

        it "should have the right title" do
          put :update, :id => @job, :job => @attr
          response.should have_selector("title", :content => "Edit job")
        end
        
        it "should not change the job's attributes" do
          put :update, :id => @job, :job => @attr
          @job.reload
          @job.job_title.should_not  == ""
        end
      
      end
      
      describe "success" do
      
        before(:each) do
          @attr = { :job_title => "Sales Junior" }
        end

        it "should change the job's attributes" do
          put :update, :id => @job, :job => @attr
          @job.reload
          @job.job_title.should  == @attr[:job_title]
        end

        it "should redirect to the job 'show' page" do
          put :update, :id => @job, :job => @attr
          response.should redirect_to job_path(@job)
        end

        it "should have a flash message" do
          put :update, :id => @job, :job => @attr
          flash[:success].should == "Successfully updated."
        end
      
      end 
      
    end
    
    describe "DELETE 'destroy'" do
      
      describe "failure when deletion is not permitted" do
      
        it "should not delete the job"
        
        it "should explain the reason why deletion was not accepted"
        
        it "should redisplay the jobs list form"
        
      end
      
      describe "success" do
      
        before(:each) do
          request.env["HTTP_REFERER"] = business_jobs_path(@business)
        end
      
        it "should destroy the job" do
          lambda do
            delete :destroy, :id => @job
          end.should change(Job, :count).by(-1)
        end

        it "should redirect to the jobs list" do
          delete :destroy, :id => @job
          response.should redirect_to(business_jobs_path(@business))
        end
        
        it "should have a success message" do
          delete :destroy, :id => @job
          flash[:success].should == @job.job_title + " has been completely removed - together with its A-Plan."
        end
      
      end
      
    end
  end

  describe "for signed-in officers who try to access jobs in someone else's business" do
   
    before(:each) do
      @user = Factory(:user)
      @business2 = Factory(:business, :name => "Not Cambiz", :sector_id => @sector.id)
      @department2 = Factory(:department, :business_id => @business2.id, :name => "Admin")
      @employee = Factory(:employee, :user_id => @user.id,
      				:business_id => @business2.id)
      @occupation = Factory(:occupation)
      @job = Factory(:job, :business_id => @business.id, :department_id => @department.id,
                           :occupation_id => @occupation.id)
      test_sign_in(@user)
    end
    
    describe "GET 'index'" do
      it "should not be successful" do
        get :index, :business_id => @business.id
        response.should_not be_success
      end
    end
    
    describe "GET 'new'" do
    
      it "should not be successful" do
        get :new, :business_id => @business.id
        response.should_not be_success
      end
     
    end
    
    describe "GET 'create'" do
      
      before(:each) do
        @title = "Sales Assistant"
        @attr = { :job_title => @title, :department_id => @department.id, :occupation_id => @occupation.id }
      end
        
      it "should redirect to the home page with an error message" do
        post :create, :business_id => @business.id, :job => @attr
        response.should redirect_to root_path
        flash[:error].should == "Illegal procedure. You can only access records in your own business."
      end
      
      it "should not create a new business" do
        lambda do
          post :create, :business_id => @business.id, :job => @attr
        end.should_not change(Job, :count)
      end
      
    end
    
    describe "GET 'edit'" do
    
      it "should not be successful" do
        get :edit, :id => @job
        response.should_not be_success
        flash[:error].should == "Illegal procedure. You can only access records in your own business."
        
      end
    
    end
    
    describe "PUT 'update'" do
      
      before(:each) do
        @attr = { :job_title => "Another job" }
      end
      
      it "should not permit job updates" do
        put :update, :id => @job, :job => @attr
        response.should redirect_to root_path
      end
      
      it "should not change the job's attributes" do
        put :update, :id => @job, :job => @attr
        @job.reload
        @job.job_title.should_not  == "Another job"
      end
    end
    
    describe "DELETE 'destroy'" do
    
      it "should not destroy the job" do
        lambda do
          delete :destroy, :id => @job
        end.should_not change(Job, :count)
      end
      
      it "should redirect to root with an error message" do
        delete :destroy, :id => @job
        response.should redirect_to root_path
        flash[:error].should == "Illegal procedure. You can only access records in your own business." 
      end
    end
  end
  
  describe "for signed-in non-officers" do
  
    before(:each) do
      @user = Factory(:user)
      #@business = Factory(business)
      @employee = Factory(:employee, :user_id => @user.id,
      				:business_id => @business.id)
      test_sign_in(@user)
    end
    
  end
  
end
