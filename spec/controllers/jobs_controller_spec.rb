require 'spec_helper'

describe JobsController do

  render_views
  
  before(:each) do
    @business = Factory(:business)
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
        @job = Factory(:job, :business_id => @business.id, :occupation_id => @occupation.id)
      end
     
      it "should not be successful" do
        get :show, :id => @job
        response.should_not be_success
      end
      
    end
    
    describe "GET 'edit'" do
    
      before(:each) do
        @occupation = Factory(:occupation)
        @job = Factory(:job, :business_id => @business.id, :occupation_id => @occupation.id)
      end
      
      it "should not be successful" do
        get :edit, :id => @job
        response.should_not be_success
      end
      
    end
    
    describe "PUT 'update'" do
    
      before(:each) do
        @occupation = Factory(:occupation)
        @job = Factory(:job, :business_id => @business.id, :occupation_id => @occupation.id)
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
        @job = Factory(:job, :business_id => @business.id, :occupation_id => @occupation.id)
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
      @job = Factory(:job, :business_id => @business.id, :occupation_id => @occupation.id)
      test_sign_in(@user)
        
    end
    
    describe "GET 'index'" do
      
      before(:each) do
        @occupation = Factory(:occupation)
        @job2 = Factory(:job, :job_title => "Merchandiser", :occupation_id => @occupation.id,
        						    :business_id => @business.id)
        @job3 = Factory(:job, :job_title => "Sales Assistant", :occupation_id => @occupation.id,
        						    :business_id => @business.id)
        @jobs = [@job, @job2, @job3]						    
      end
      
      it "should be successful" do 
        get :index, :business_id => @business.id
        response.should be_success
      end
      
      it "should have the right title" do
        get :index, :business_id => @business.id
        response.should have_selector("title",
          	:content => "Jobs at #{@business.name}")
      end
      
      it "should display each of the jobs" do
        get :index, :business_id => @business.id
        @jobs.each do |job|
          response.should have_selector("td", :content => job.job_title)
        end
      end
      
      it "should not display jobs from another business" do
        @business2 = Factory(:business, :name => "Not Cambiz")
        @employee2 = Factory(:employee, :user_id => @user.id, :business_id => @business2.id)
        @job_99 = Factory(:job, :job_title => "Another job", :business_id => @business2.id,
                                                    :occupation_id => @occupation.id)
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
          response.should have_selector("td", :content => job.occupation.name)
        end
      end
      
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
        response.should have_selector("title", :content => @job.job_title)
      end
      
      it "should include the business name" do
        get :show, :id => @job
        response.should have_selector("p", :content => @job.business.name)
      end
      
      it "should include the job category" do
        get :show, :id => @job
        response.should have_selector("p", :content => @job.occupation.name)
      end
      
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
      
      describe "when the job has no A-Plan" do
      
        it "should have a link to a new A-Plan" 
        
      end
      
      describe "when the job has an A-Plan" do
      
        it "should have a link to the A-Plan show-page"
        
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
                            :content => "New job: #{@business.name}")
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
          @attr = { :job_title => @title }
        end

        it "should not create a job" do
          lambda do
            post :create, :business_id => @business.id, :job => @attr
          end.should_not change(Job, :count)
        end

        it "should have the right title" do
          post :create, :business_id => @business.id, :job => @attr
          response.should have_selector("title", :content => "New job: #{@business.name}")
        end

        it "should render the 'new' page" do
          post :create, :business_id => @business.id, :job => @attr
          response.should render_template('new')
        end
      
      end
      
      describe "success" do
       
        before(:each) do
          @title = "Sales Assistant"
          @attr = { :job_title => @title, :occupation_id => @occupation.id }
        end
        
        it "should create a job" do
          lambda do
            post :create, :business_id => @business.id, :job => @attr
          end.should change(Job, :count).by(1)
        end

        it "should redirect to the jobs list" do
          post :create, :business_id => @business.id, :job => @attr
          response.should redirect_to business_jobs_path(@business)
        end
      
        it "should have a success message" do
          post :create, :business_id => @business.id, :job => @attr
          flash[:success].should == @title + " added."
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
        response.should have_selector("title", :content => "Edit job: #{@business.name}")
      end
      
      it "should have a 'change' button" do
        get :edit, :id => @job
        response.should have_selector("input", :type => "submit", :value => "Confirm")
      end
      
      it "should have a 'cancel' button" do
        get :edit, :id => @job
        response.should have_selector("a", :href => business_jobs_path(@business),
        				   :content => "Cancel")
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
          response.should have_selector("title", :content => "Edit job: #{@business.name}")
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
          flash[:success].should == @job.job_title + " removed."
        end
      
      end
      
    end
  end

  describe "for signed-in officers who try to access jobs in someone else's business" do
   
    before(:each) do
      @user = Factory(:user)
      @business2 = Factory(:business, :name => "Not Cambiz")
      @employee = Factory(:employee, :user_id => @user.id,
      				:business_id => @business2.id)
      @occupation = Factory(:occupation)
      @job = Factory(:job, :business_id => @business.id, 
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
        @attr = { :job_title => @title, :occupation_id => @occupation.id }
      end
        
      it "should redirect to the home page with an error message" do
        post :create, :business_id => @business.id, :job => @attr
        response.should redirect_to root_path
        flash[:error].should == "Illegal procedure. You can only access jobs in your own business."
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
        flash[:error].should == "Illegal procedure. You can only access jobs in your own business."
        
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
        flash[:error].should == "Illegal procedure. You can only access jobs in your own business." 
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
