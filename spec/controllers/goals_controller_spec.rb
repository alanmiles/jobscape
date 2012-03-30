require 'spec_helper'

describe GoalsController do

  render_views
  
  before(:each) do
    @business = Factory(:business)
    @department = Factory(:department, :business_id => @business.id)
    @occupation = Factory(:occupation)
    @job = Factory(:job, :business_id => @business.id, :department_id => @department.id, :occupation_id => @occupation.id)
    session[:jobid] = @job.id
    @plan = Plan.find_by_job_id(@job.id)
    @responsibility = Factory(:responsibility, :plan_id => @plan.id)
    @goal = Factory(:goal, :responsibility_id => @responsibility.id)
    session[:responid] = @responsibility.id
    @user = Factory(:user)
  end
  
  describe "for non-signed-in users" do
  
    describe "GET 'new'" do
        
      it "should not be successful" do
        get 'new', :responsibility_id => @responsibility.id
        response.should_not be_success
      end
        
    end
  
  end
  
  describe "for signed-in admins" do
  
  end
  
  describe "for signed-in officers" do
  
    before(:each) do
      @employee = Factory(:employee, :user_id => @user.id, 
      			  :business_id => @business.id,
      			  :ref_no => 1,
      			  :officer => true)
      test_sign_in(@user)    
    end
    
    describe "setting goals for their own business" do
    
      describe "GET 'new'" do
        
        describe "if there are already 3 goals for the responsibility" do

          before(:each) do
            @goal2 = Factory(:goal, :responsibility_id => @responsibility.id,
                                    :objective => "Goal2")
            @goal3 = Factory(:goal, :responsibility_id => @responsibility.id,
                                    :objective => "Goal3")
          end
        
          it "should not be successful" do
            get 'new', :responsibility_id => @responsibility.id
            response.should_not be_success
          end
          
          it "should redirect to the responsibility 'show' page" do
            get 'new', :responsibility_id => @responsibility.id
            response.should redirect_to responsibility_path(@responsibility)
          end
          
        end
        
        describe "if there are fewer than 3 goals for the responsibility" do
        
          it "should be successful" do
            get 'new', :responsibility_id => @responsibility.id
            response.should be_success
          end
        
          it "should have the right title" do
            get 'new', :responsibility_id => @responsibility.id
            response.should have_selector("title", :content => "New goal")
          end
        
          it "should mention the job and business" do
            get 'new', :responsibility_id => @responsibility.id
            response.should have_selector("h1", 
                  :content => @job.job_title)
          end
        
          it "should mention the responsibility" do
            get 'new', :responsibility_id => @responsibility.id
            response.should have_selector(".subtext", 
                  :content => @responsibility.definition)
          end
        
          it "should have a link to the responsibility 'show' page" do
            get 'new', :responsibility_id => @responsibility.id
            response.should have_selector("a", 
                  :href => responsibility_goals_path(@responsibility))
          end
        
          it "should have an 'objective' text area" do
            get 'new', :responsibility_id => @responsibility.id
            response.should have_selector("textarea", 
                    :name => "goal[objective]")
          end
        
          it "should have a hidden field - created_by" do
            get 'new', :responsibility_id => @responsibility.id
            response.should have_selector("input", 
                    :name => "goal[created_by]",
                    :type => "hidden")
          end
        
          it "should have a create button" do
            get 'new', :responsibility_id => @responsibility.id
            response.should have_selector("input", 
                    :type => "submit", 
                    :value => "Create Goal")
          end
          
        end
        
      end
      
      describe "POST 'create'" do
      
        describe "if the responsibility already has 3 goals" do
        
          before(:each) do
            @goal2 = Factory(:goal, :responsibility_id => @responsibility.id,
                                    :objective => "Goal2")
            @goal3 = Factory(:goal, :responsibility_id => @responsibility.id,
                                    :objective => "Goal3")
            @obj = "New objective"
            @attr = { :objective => @obj, :created_by => @user.id }
          end
          
          it "should not create a goal" do
            lambda do
              post :create, :responsibility_id => @responsibility.id, :goal => @attr
            end.should_not change(Goal, :count)
          end

          #it "should have the right title" do
          #  post :create, :responsibility_id => @responsibility.id, :goal => @attr
          #  response.should have_selector("title", 
          #                 :content => "Responsibility for #{@job.job_title}")
          #end

          it "should redirect to the responsibilities 'show' page" do
            post :create, :responsibility_id => @responsibility.id, :goal => @attr
            response.should redirect_to(responsibility_goals_path(@responsibility))
          end
          
        end
        
        describe "if the responsibility has less than 3 goals" do
        
          describe "failure" do
          
            before(:each) do
              @obj = ""
              @attr = { :objective => @obj }
            end

            it "should not create a goal" do
              lambda do
                post :create, :responsibility_id => @responsibility.id, :goal => @attr
              end.should_not change(Goal, :count)
            end

            it "should have the right title" do
              post :create, :responsibility_id => @responsibility.id, :goal => @attr
              response.should have_selector("title", 
                           :content => "New goal")
            end

            it "should render the 'new' page" do
              post :create, :responsibility_id => @responsibility.id, :goal => @attr
              response.should render_template('new')
            end
        
          end
        
          describe "success" do
        
            before(:each) do
              @obj = "New objective"
              @attr = { :objective => @obj, :created_by => @user.id }
            end
        
            it "should create a goal" do
              lambda do
                post :create, :responsibility_id => @responsibility.id, :goal => @attr
              end.should change(Goal, :count).by(1)
            end

            it "should redirect to the responsibility show page" do
              post :create, :responsibility_id => @responsibility.id, :goal => @attr
              response.should redirect_to responsibility_goals_path(@responsibility)
            end
      
            it "should have a success message" do
              post :create, :responsibility_id => @responsibility.id, :goal => @attr
              flash[:success].should == "Goal successfully added."
            end    
       
            it "should be connected to the correct responsibility" do
              post :create, :responsibility_id => @responsibility.id, :goal => @attr
              @goal = Goal.last
              @goal.responsibility_id.should == @responsibility.id
            end
          
            it "should show the current user as creator" do
              post :create, :responsibility_id => @responsibility.id, :goal => @attr
              @goal = Goal.last
              @goal.created_by.should == @user.id
            end
          
            describe "after the third goal has been added" do
          
              before(:each) do
            	@goal2 = Factory(:goal, :responsibility_id => @responsibility.id,
                                        :objective => "Goal2")
              end
              
              it "should state that all goals have now been set" do
                post :create, :responsibility_id => @responsibility.id, :goal => @attr
                flash[:notice].should == "You've now set all three goals for the responsibility"
              end
            end
          end
        end
        
      end
      
      describe "GET 'edit'" do
      
        it "should be successful" do
          get :edit, :id => @goal.id
          response.should be_success
        end
      
        it "should have the right title" do
          get :edit, :id => @goal.id
          response.should have_selector("title", :content => "Edit goal")
        end
        
        it "should have a 'cancel' link back to the responsibility 'show' page" do
          get :edit, :id => @goal.id
          response.should have_selector("a", :href => responsibility_goals_path(@responsibility))
        end
        
        it "should have a 'confirm changes' button" do
          get :edit, :id => @goal.id
          response.should have_selector("input", 
                    :type => "submit", 
                    :value => "Update Goal")
        end
        
        it "should have an edit box for the objective" do
          get :edit, :id => @goal.id
          response.should have_selector("textarea", 
                    :name => "goal[objective]")
        
        end
        
        #no longer required
        
        #it "should have a 'removed' check box" do
        #  get :edit, :id => @goal.id
        #  response.should have_selector("input", 
        #            :name => "goal[removed]",
        #            :type => "checkbox")
        #end
        
      end
     
     describe "PUT 'update'" do
      
        describe "when the removed button is checked" do
        
          describe "when the goal has been used in an appraisal" do
          
            it "should not be deleted"
            
            it "should be saved with a removed date"
            
            it "should save the current_user id as the last to update"
            
          end
          
          describe "when the goal has never been used in an appraisal" do
          
            it "should be deleted"
            
            it "should have a flash message explaining the deletion"
            
            it "should redirect to the responsibilities 'show' page for this job"
          end
        
        end
        
        describe "when the removed button is unchecked" do
        
          describe "failure" do
          
            before(:each) do
              @attr = { :objective => ""}
            end
        
            it "should not change the number of goals" do
              lambda do
                put :update, :id => @goal, :goal => @attr
              end.should_not change(Goal, :count)
            end
            
            it "should render the 'edit' page" do
              put :update, :id => @goal, :goal => @attr
              response.should render_template('edit')
            end

            it "should have the right title" do
              put :update, :id => @goal, :goal => @attr
              response.should have_selector("title", :content => "Edit goal")
            end
        
            it "should not change the goal's attributes" do
              put :update, :id => @goal, :goal => @attr
              @goal.reload
              @goal.objective.should_not  == ""
              @goal.removed.should == false
            end
          
          end
          
          describe "success" do
          
            before(:each) do
              @attr = { :objective => "Brand new goal",
                        :updated_by => @user.id }
            end
            
            it "should not change the number of goals" do
              lambda do
                put :update, :id => @goal, :goal => @attr
              end.should_not change(Goal, :count)
            end

            it "should change the goal's attributes" do
              put :update, :id => @goal, :goal => @attr
              @goal.reload
              @goal.objective.should  == @attr[:objective]
              @goal.removed.should == false
            end
            
            it "should save the current user as the last updater" do
              put :update, :id => @goal, :goal => @attr
              @goal.reload
              @goal.updated_by.should  == @user.id
            end

            it "should redirect to the goals list for the responsibility" do
              put :update, :id => @goal, :goal => @attr
              response.should redirect_to responsibility_goals_path(@responsibility)
            end

            it "should have a flash message" do
              put :update, :id => @goal, :goal => @attr
              flash[:success].should == "Goal successfully updated."
            end
          end
        
        end
        
      end 
      
      describe "DELETE 'destroy'" do
        
        describe "when the goal has been used in appraisals" do
        
          it "should not delete the goal"
         
          it "should hide the goal"
          
          it "should set a removal date"
          
          it "should set the current user as the remover"
          
          it "should redirect to the responsibility 'show' page"
          
          it "should set a flash message explaining that the goal has been hidden"
          
        end
        
        describe "when the goal has not been used in appraisals" do
        
          it "should destroy the goal" do
            lambda do
              delete :destroy, :id => @goal
            end.should change(Goal, :count).by(-1)
          end

          it "should redirect to the responsibilities 'show' page" do
            delete :destroy, :id => @goal
            response.should redirect_to(responsibility_goals_path(@responsibility))
          end
        
          it "should have a success message" do
            delete :destroy, :id => @goal
            flash[:success].should == "Goal successfully deleted."
          end
        
        end
      
      end
    end
    
    describe "setting goals for someone else's business" do
    
    end
  end

  describe "for signed in employees" do
  
    describe "working with goals in their own job" do
    
    end
    
    describe "working with goals in someone else's job" do
    
    end
  end
end
