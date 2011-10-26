require 'spec_helper'

describe ResponsibilitiesController do

  render_views
  
  before(:each) do
    @business = Factory(:business)
    @occupation = Factory(:occupation)
    @job = Factory(:job, :business_id => @business.id, :occupation_id => @occupation.id)
    session[:jobid] = @job.id
    @plan = Plan.find_by_job_id(@job.id)
    @responsibility = Factory(:responsibility, :plan_id => @plan.id)
  end
  
  describe "for a non-signed-in user" do
  
    describe "GET 'index'" do
      it "should not be successful" do
        get :index, :plan_id => @plan.id
        response.should_not be_success
      end
      
      it "should redirect to signin" do
        get :index, :plan_id => @plan.id
        response.should redirect_to signin_path
      end
    end

    describe "GET 'new'" do
      it "should not be successful" do
        get :new, :plan_id => @plan.id
        response.should_not be_success
      end
      
      it "should redirect to signin" do
        get :new, :plan_id => @plan.id
        response.should redirect_to signin_path
      end
    end
  end
  
  describe "for a signed-in administrator" do
  
  end
  
  describe "for a signed-in officer" do

    before(:each) do
      @user = Factory(:user)
      @employee = Factory(:employee, :user_id => @user.id, 
      				     :business_id => @business.id, 
      				     :officer => true)
      test_sign_in(@user)
    end
      
    describe "jobs in own business" do
      
      describe "GET 'index'" do
      
        before(:each) do
          @responsibility2 = Factory(:responsibility, :plan_id => @plan.id,
                                     :definition => "A second responsibility",
                                     :rating => 90 )
          @responsibility3 = Factory(:responsibility, :plan_id => @plan.id,
                                     :definition => "A third responsibility",
                                     :rating => 0 )
          @responsibilities = [@responsibility, @responsibility2, @responsibility3]
        end
        
        it "should be successful" do
          get :index, :plan_id => @plan.id
          response.should be_success
        end
        
        it "should have the right title" do
          get :index, :plan_id => @plan.id
          response.should have_selector("title", 
                          :content => "Responsibilities: #{@job.job_title}")
        end
        
        it "should have an 'add a responsibility' link (if < 21 responsibilities)" do
          get :index, :plan_id => @plan.id
          response.should have_selector("a", :href => new_plan_responsibility_path(@plan))
        end
        
        it "should not allow more than 20 responsibilities to be added" do
          17.times do
            @responsibilities << Factory(:responsibility, :definition => Factory.next(:definition),
                                         :plan_id => @plan.id)
          end
          get :index, :plan_id => @plan.id
          response.should_not have_selector("a", :href => new_plan_responsibility_path(@plan))
          response.should have_selector("div.r-float", 
                                        :content => "No more responsibilities can be added")
        end
        
        it "should have a 'return to A-Plan menu' link" do
          get :index, :plan_id => @plan.id
          response.should have_selector("a", :href => plan_path(@plan))
        end
        
        it "should list all current responsibilities for this job" do
          get :index, :plan_id => @plan.id
          @responsibilities[0..2].each do |responsibility|
            response.should have_selector("td", :content => responsibility.definition)
          end
        end
        
        it"should have a link to the 'show' page for each responsibility" do
          get :index, :plan_id => @plan.id
          @responsibilities[0..2].each do |responsibility|
            response.should have_selector("a", :href => responsibility_path(responsibility))
          end
        end
        
        it "should show the responsibility rating"
        #  get :index, :plan_id => @plan.id
        #  @responsibilities[0..2].each do |responsibility|
        #    unless responsibility.rating == 0
        #      response.should have_selector("td", :content => responsibility.rating.to_s)
        #    end
        #  end
        #end
        #OR SHOULD SHOW 'n/a' IF NO RATING
        
        it "should display 'n/a' if the rating is 0" do
          get :index, :plan_id => @plan.id
          @responsibilities[0..2].each do |responsibility|
            if responsibility.rating == 0
              response.should have_selector("td", :content => "n/a")
            end
          end
        end
        
        it "should have a 'remove' button for each element" do
          get :index, :plan_id => @plan.id
          @responsibilities.each do |responsibility|
            response.should have_selector("a", :title => "Remove this responsibility.")
            
            
          end
        end
        
        it "should show how many goals have been created for the responsibility" do
          @goal1 = Factory(:goal, :responsibility_id => @responsibility.id)
          @goal2 = Factory(:goal, :objective => "Second goal", 
                                  :responsibility_id => @responsibility.id)
          get :index, :plan_id => @plan.id
          response.should have_selector("td.numeric", :content => "2")                     
        end
         
        it "should rank the responsibilities by rating (descending)"
               
        it "should have a link to the show page for each responsibility" do
          get :index, :plan_id => @plan.id
          @responsibilities[0..2].each do |responsibility|
            response.should have_selector("a", :href => responsibility_path(responsibility))
          end
        end
        
        it "should not show 'removed' responsibilities for the job" do
          @responsibility4 = Factory(:responsibility, :plan_id => @plan.id,
                                     :definition => "A fourth responsibility",
                                     :rating => 0, :removed => true )
          @responsibilities << @responsibility4
          get :index, :plan_id => @plan.id
          @responsibilities.each do |responsibility|
            response.should_not have_selector("td", 
                            :content => @responsibility4.definition)
          end
        end
        
        it "should not show responsibilities for other jobs" do
          @job2 = Factory(:job, :job_title => "Other job",
          			:business_id => @business.id, 
          			:occupation_id => @occupation.id)
    	  @plan2 = Plan.find_by_job_id(@job2.id)
    	  @responsibility5 = Factory(:responsibility, :plan_id => @plan2.id,
                                     :definition => "A fifth responsibility",
                                     :rating => 25 )
          @responsibilities << @responsibility5
          get :index, :plan_id => @plan.id
          @responsibilities.each do |responsibility|
            response.should_not have_selector("td", 
                            :content => @responsibility5.definition)
          end
        end
      end

      describe "GET 'new'" do
        
        describe "if there are already 20 responsibilities for the job" do
          
          it "should not be successful" do
            @responsibilities = [@responsibility]
            19.times do
              @responsibilities << Factory(:responsibility, 
                                           :definition => Factory.next(:definition),
                                           :plan_id => @plan.id)
            end
            get :new, :plan_id => @plan.id
            response.should_not be_success
          end
 
        end
        
        describe "if there are fewer than 20 responsibilities for the job" do
        
          it "should be successful" do
            get :new, :plan_id => @plan.id
            response.should be_success
          end
        
          it "should have the right title" do
            get :new, :plan_id => @plan.id
            response.should have_selector("title", 
                      :content => "New responsibility: #{@job.job_title}")
          end
        
          it "should have a 'cancel' option" do
            get :new, :plan_id => @plan.id
            response.should have_selector("a", 
                    :href => plan_responsibilities_path(@plan),
          	    :content => "Cancel")
          end
        
          it "should have a 'definition' text area" do
            get :new, :plan_id => @plan.id
            response.should have_selector("textarea", 
                    :name => "responsibility[definition]")
          end
        
          it "should have a hidden field - created_by" do
            get :new, :plan_id => @plan.id
            response.should have_selector("input", 
                    :name => "responsibility[created_by]",
                    :type => "hidden")
          end
        
          it "should have a create button" do
            get :new, :plan_id => @plan.id
            response.should have_selector("input", 
                    :type => "submit", 
                    :value => "Create")
          end
        end
      
      end
      
      describe "POST 'create'" do
      
        describe "if there are already 20 responsibilities for the job" do
        
          before(:each) do
            @responsibilities = [@responsibility]
            19.times do
              @responsibilities << Factory(:responsibility, 
                                           :definition => Factory.next(:definition),
                                           :plan_id => @plan.id)
            end
            @def = "New responsibility"
            @attr = { :definition => @def, :created_by => @user.id }
          end
        
          it "should not create a responsibility" do
            lambda do
              post :create, :plan_id => @plan.id, :responsibility => @attr
            end.should_not change(Responsibility, :count)
          end

          it "should render the job's responsibility list page" do
            post :create, :plan_id => @plan.id, :responsibility => @attr
            response.should redirect_to plan_responsibilities_path(@plan)
          end
          
        end
        
        describe "if there are fewer than 20 responsibilities for the job" do
        
          describe "failure" do
          
            before(:each) do
              @def = ""
              @attr = { :definition => @def }
            end

            it "should not create a responsibility" do
              lambda do
                post :create, :plan_id => @plan.id, :responsibility => @attr
              end.should_not change(Responsibility, :count)
            end

            it "should have the right title" do
              post :create, :plan_id => @plan.id, :responsibility => @attr
              response.should have_selector("title", 
                           :content => "New responsibility: #{@job.job_title}")
            end

            it "should render the 'new' page" do
              post :create, :plan_id => @plan.id, :responsibility => @attr
              response.should render_template('new')
            end
        
          end
        
          describe "success" do
        
            before(:each) do
              @def = "New responsibility"
              @attr = { :definition => @def, :created_by => @user.id }
            end
        
            it "should create a responsibility" do
              lambda do
                post :create, :plan_id => @plan.id, :responsibility => @attr
              end.should change(Responsibility, :count).by(1)
            end

            it "should redirect to the responsibility show page" do
              post :create, :plan_id => @plan.id, :responsibility => @attr
              @responsibility = Responsibility.last
              response.should redirect_to responsibility_path(@responsibility)
            end
      
            it "should have a success message" do
              post :create, :plan_id => @plan.id, :responsibility => @attr
              flash[:success].should =~ /now add up to 3 goals, and then set the Rating./i
            end    
       
            it "should be connected to the correct plan" do
              post :create, :plan_id => @plan.id, :responsibility => @attr
              @responsibility = Responsibility.last
              @responsibility.plan_id.should == @plan.id
            end
          
            it "should show the current user as creator" do
              post :create, :plan_id => @plan.id, :responsibility => @attr
              @responsibility = Responsibility.last
              @responsibility.created_by.should == @user.id
            end
            
            describe "when the job's 20th responsibility has been created" do
            
              before(:each) do
                18.times do
                  @responsibilities = [@responsibility]
                  @responsibilities << Factory(:responsibility, 
                                           :definition => Factory.next(:definition),
                                           :plan_id => @plan.id)
                end
              end
              
              it "should have a flash message explaining no more can be created" do  
                post :create, :plan_id => @plan.id, :responsibility => @attr
                flash[:notice].should == "You've now set the maximum number of responsibilities for the job"   
              end
            end
          end
        end
      end
      
      describe "GET 'show'" do
      
        it "should be successful" do
          get :show, :id => @responsibility.id
          response.should be_success
        end
        
        it "should have the right title" do
          get :show, :id => @responsibility.id
          response.should have_selector("title", 
               :content => "Responsibility for #{@job.job_title}")
        end
        
        it "should have an 'edit' link" do
          get :show, :id => @responsibility.id
          response.should have_selector("a", :href => edit_responsibility_path(@responsibility))
        end
        
        it "should have a link to responsibilities list for current job" do
          get :show, :id => @responsibility.id
          response.should have_selector("a", :href => plan_responsibilities_path(@plan))
        end
        
        it "should have a link to 'add a new goal'" do
          get :show, :id => @responsibility.id
          response.should have_selector("a", 
                     :href => new_responsibility_goal_path(@responsibility))
        end
        
        describe "showing the responsibility's goals" do
          
          before(:each) do
            @responsibility2 = Factory(:responsibility, :plan_id => @plan.id,
                                     :definition => "A second responsibility",
                                     :rating => 90 )
            @goal1 = Factory(:goal, :responsibility_id => @responsibility.id)
            @goal2 = Factory(:goal, :objective => "Goal 2",
                                    :responsibility_id => @responsibility.id)
            @wrong_resp_goal = Factory(:goal, :objective => "Goal wrong",
                                    :responsibility_id => @responsibility2.id)
            @goals = [@goal1, @goal2]
          end
                    
          it "should show the responsibility's goals" do
            get :show, :id => @responsibility.id
            response.should have_selector("td", :content => @goal1.objective)
            response.should have_selector("td", :content => @goal2.objective)
          end
          
          it "should not show goals for different responsibilities" do
            get :show, :id => @responsibility.id
            response.should_not have_selector("td", :content => @wrong_resp_goal.objective)
          end 
          
          it "should have an 'edit' button for each goal" do
            get :show, :id => @responsibility.id
            @goals.each do |goal|
              response.should have_selector("a", :href => edit_goal_path(goal))
            end
          end
          
          it "should have a 'Remove' button for each goal" do
            get :show, :id => @responsibility.id
            @goals.each do |goal|
              response.should have_selector("a", :title => "Remove goal.")
            end
          end
          
          describe "if there are already 3 goals" do
            
            before(:each) do
              @goal3 = Factory(:goal, :objective => "Goal 3",
                                    :responsibility_id => @responsibility.id)
              @goals << @goal3
            end
            
            it "should not allow another goal to be added" do
              get :show, :id => @responsibility.id
              response.should_not have_selector("a", 
                     :href => new_responsibility_goal_path(@responsibility))
            end
            
            it "should state that 3 goals is the maximum" do
              get :show, :id => @responsibility.id
              response.should have_selector("div.r-float", 
              			:content => "3 goals is the maximum")
            end
          
          end 
        end
      end
      
      describe "GET 'edit'" do
      
        it "should be successful" do
          get :edit, :id => @responsibility.id
          response.should be_success
        end
      
        it "should have the right title" do
          get :edit, :id => @responsibility.id
          response.should have_selector("title", :content => "Edit responsibility")
        end
        
        it "should have a 'cancel' link back to the 'show' page" do
          get :edit, :id => @responsibility.id
          response.should have_selector("a", :href => responsibility_path(@responsibility))
        end
        
        it "should have a 'confirm changes' button" do
          get :edit, :id => @responsibility.id
          response.should have_selector("input", 
                    :type => "submit", 
                    :value => "Confirm changes")
        end
        
        it "should have an edit box for the definition" do
          get :edit, :id => @responsibility.id
          response.should have_selector("textarea", 
                    :name => "responsibility[definition]")
        
        end
        
        it "should have a 'removed' check box" do
          get :edit, :id => @responsibility.id
          response.should have_selector("input", 
                    :name => "responsibility[removed]",
                    :type => "checkbox")
        end
        
      end
      
      describe "PUT 'update'" do
      
        describe "when the removed button is checked" do
        
          describe "when the responsibility has been used in an appraisal" do
          
            it "should not be deleted"
            
            it "should be saved with a removed date"
            
            it "should save the current user id as the last to update"
            
          end
          
          describe "when the responsibility has never been used in an appraisal" do
          
            it "should be deleted"
            
            it "should have a flash message explaining the deletion"
            
            it "should redirect to the responsibilities list for this job"
          end
        
        end
        
        describe "when the removed button is unchecked" do
        
          describe "failure" do
          
            before(:each) do
              @attr = { :definition => ""}
            end
        
            it "should not change the number of responsibilities" do
              lambda do
                put :update, :id => @responsibility, :responsibility => @attr
              end.should_not change(Responsibility, :count)
            end
            
            it "should render the 'edit' page" do
              put :update, :id => @responsibility, :responsibility => @attr
              response.should render_template('edit')
            end

            it "should have the right title" do
              put :update, :id => @responsibility, :responsibility => @attr
              response.should have_selector("title", :content => "Edit responsibility")
            end
        
            it "should not change the responsibility's attributes" do
              put :update, :id => @responsibility, :responsibility => @attr
              @responsibility.reload
              @responsibility.definition.should_not  == ""
              @responsibility.removed.should == false
            end
          
          end
          
          describe "success" do
          
            before(:each) do
              @attr = { :definition => "New definition",
                        :updated_by => @user.id }
            end
            
            it "should not change the number of responsibilities" do
              lambda do
                put :update, :id => @responsibility, :responsibility => @attr
              end.should_not change(Responsibility, :count)
            end

            it "should change the responsibility's attributes" do
              put :update, :id => @responsibility, :responsibility => @attr
              @responsibility.reload
              @responsibility.definition.should  == @attr[:definition]
              @responsibility.removed.should == false
            end
            
            it "should save the current user as the last updater" do
              put :update, :id => @responsibility, :responsibility => @attr
              @responsibility.reload
              @responsibility.updated_by.should  == @user.id
            end

            it "should redirect to the responsibility 'show' page" do
              put :update, :id => @responsibility, :responsibility => @attr
              response.should redirect_to responsibility_path(@responsibility)
            end

            it "should have a flash message" do
              put :update, :id => @responsibility, :responsibility => @attr
              flash[:success].should == "Successfully updated."
            end
          end
        
        end
      
      end
      
      describe "DELETE 'destroy'" do
      
        describe "when the responsibility has been used in an appraisal" do
        
          it "should not delete the responsibility"
          
          it "should set the 'removed' field to true"
          
          it "should set the removal date"
          
          it "should set 'updated by' to the current user's id"
          
          it "should have a flash message explaining that the responsibility has been hidden"
        
        end
        
        describe "when the responsibility has not been used in an appraisal" do
        
          describe "failure" do
          
            it "should not delete the responsibility"
            
            it "should display the responsibilities list for the job"
            
            it "should have a flash message saying that it cannot be deleted"
          end
          
          describe "success" do
          
            it "should destroy the responsibility" do
              lambda do
                delete :destroy, :id => @responsibility
              end.should change(Responsibility, :count).by(-1)
            end

            it "should redirect to the responsibilities list for the job" do
              delete :destroy, :id => @responsibility
              response.should redirect_to(plan_responsibilities_path(@plan))
            end
        
            it "should have a success message" do
              delete :destroy, :id => @responsibility
              flash[:success].should =~ /Responsibility successfully deleted/i
            end
          end
        end
      end
    end
    
    describe "jobs in someone else's business" do
    
    end
  end
  
  describe "for a signed-in employee" do
  
    describe "own job-plan" do
    
    end
    
    describe "someone else's job-plan" do
    
    end
  
  end
end
