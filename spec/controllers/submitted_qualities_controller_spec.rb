require 'spec_helper'

describe SubmittedQualitiesController do
  
  render_views
  
  before(:each) do
    @sector = Factory(:sector)
    @user = Factory(:user)
    @user2 = Factory(:user, :email => "user2@example.com")
    @quality1 = Factory(:quality, :approved => true)
    @quality2 = Factory(:quality, :quality => "Second quality", :approved => true) 
    @quality3 = Factory(:quality, :quality => "Third quality", :approved => true)
    @unapproved_quality = Factory(:quality, :quality => "Fourth quality", 
    				:seen => true, :created_by => @user.id)
    @removed_quality = Factory(:quality, :quality => "Fifth quality", 
                               :removed => true, :created_by => @user.id)
    @unseen_quality1 = Factory(:quality, :quality => "Sixth quality",
                                :created_by => @user.id)
    @unseen_quality2 = Factory(:quality, :quality => "Seventh quality",
                               :created_by => @user.id)
    @other_user_submission = Factory(:quality, :quality => "Other user", 
                                     :created_by => @user2.id)
    
    @qualities = [@quality1, @quality2, @quality3, @unapproved_quality, @removed_quality, @unseen_quality1, @unseen_quality2]
  end
  
  describe "for non-signed-in users" do
    
    describe "GET 'index'" do
      
      it "should not be successful" do
        get 'index'
        response.should_not be_success
      end
    end
    
  end
  
  describe "for signed-in non-admins" do
  
    before(:each) do
      test_sign_in(@user)
    end
    
    describe "GET 'index'" do
      
      it "should not be successful" do
        get 'index'
        response.should_not be_success
      end
    end
    
    describe "GET 'new'" do
    
      before(:each) do
        @business = Factory(:business, :sector_id => @sector.id)
        @occupation = Factory(:occupation)
        @job = Factory(:job, :business_id => @business.id, 
        		:occupation_id => @occupation.id)
        session[:jobid] = @job.id		
        @plan = Plan.find_by_job_id(@job.id)
      end
      
      it "should be successful" do
        get :new
        response.should be_success
      end
      
      it "should have the right title" do
        get :new
        response.should have_selector("title", 
           :content => "Attribute suggestion")
      end
    
      it "should have an entry box for 'quality'" do
        get :new
        response.should have_selector("input",
        		:name => "quality[quality]")
      end
      
      it "should have a hidden field for 'created_by'" do
        get :new
        response.should have_selector("input",
        		:name => "quality[created_by]",
        		:type => "hidden")
      end
      
      it "should have a 'Suggest' button" do
        get :new
        response.should have_selector("input", 
            	    :type => "submit", 
                    :value => "Suggest now")     
      end
      
      it "should have a link back to the new attribute selection page" do
        get :new
        response.should have_selector("a", 
            	    :href => new_plan_jobquality_path(@plan))
      end
      
    end
    
    describe "POST 'create'" do
      
      before(:each) do
        @business = Factory(:business, :sector_id => @sector.id)
        @occupation = Factory(:occupation)
        @job = Factory(:job, :business_id => @business.id, 
        		:occupation_id => @occupation.id)
        session[:jobid] = @job.id		
        @plan = Plan.find_by_job_id(@job.id)
      end
      
      describe "failure" do
      
        before(:each) do
          @attr = { :quality => "" }
        end
      
        it "should not create a new quality" do
          lambda do
            post :create, :quality => @attr
          end.should_not change(Quality, :count)
        end
        
        it "should not create new PAMs" do
          lambda do
            post :create, :quality => @attr
          end.should_not change(Pam, :count)
        end
        
        it "should have the correct title" do
          post :create, :quality => @attr
          response.should have_selector("title", 
                   :content => "New attribute submissions")
        end
        
        it "should render the 'new' page" do
          post :create, :quality => @attr
          response.should render_template('new')
        end
        
      end
      
      describe "success" do
      
        before(:each) do
          @attr = { :quality => "Successful quality",
          	    :created_by => @user.id }
        end
      
        it "should create a new attribute" do
          lambda do
            post :create, :quality => @attr
          end.should change(Quality, :count).by(1)
        end
        
        it "should create 5 new PAMs" do
          lambda do
            post :create, :quality => @attr
          end.should change(Pam, :count).by(5)
        end
        
        it "should redirect to the submitted quality 'show' page" do
          post :create, :quality => @attr
          response.should redirect_to(submitted_quality_path(assigns(:quality)))
        end
        
        it "should generate a flash guidance message" do
          post :create, :quality => @attr
          @quality = assigns(:quality)
          flash[:success].should == "#{@quality.quality} added. Now improve the 5 PAMs."
        end
          
        it "should set 'approved' to false" do
          post :create, :quality => @attr
          @quality = assigns(:quality)
          @quality.approved.should == false
        end
          
        it "should set 'seen' to false" do
          post :create, :quality => @attr
          @quality = assigns(:quality)
          @quality.seen.should == false
        end
        
        it "should set 'created_by' to the user_id" do
          post :create, :quality => @attr
          @quality = assigns(:quality)
          @quality.created_by.should == @user.id
        end
      end
    end
    
    describe "GET 'show'" do
      
      before(:each) do
        @business = Factory(:business, :sector_id => @sector.id)
        @occupation = Factory(:occupation)
        @job = Factory(:job, :business_id => @business.id, 
        		:occupation_id => @occupation.id)
        session[:jobid] = @job.id		
        @plan = Plan.find_by_job_id(@job.id)
      end
      
      describe "created by others" do
      
        it "should not be successful" do
          get :show, :id => @other_user_submission
          response.should_not be_success
        end
        
      end
      
      describe "created by self" do
      
        it "should be successful" do
          get :show, :id => @unseen_quality1
          response.should be_success
        end
      
        it "should have the right title" do
          get :show, :id => @unseen_quality1
          response.should have_selector("title", 
            :content => "Attribute submission: #{@unseen_quality1.quality}")
        end
      
        it "should contain the attribute name" do
          get :show, :id => @unseen_quality1
          response.should have_selector("p.display_text",
            :content => "#{@unseen_quality1.quality}")
        end
    
        it "should have a link back to the new attribute selection page" 
          #Test the return_to link with an integration 
      
        it "should have a link to the attribute 'edit' page" do
          get :show, :id => @unseen_quality1
          response.should have_selector("a", 
                  :href => edit_submitted_quality_path(@unseen_quality1))
        end
    
        describe "showing the attribute's grades" do
          
          before(:each) do
            @pams = []
            @unseen_quality3 = Factory(:quality, :quality => "Eighth quality")
            @pama = Pam.find(:first, 
              :conditions => ["quality_id = ? and grade = ?", @unseen_quality3.id, "A"])
            @pamb = Pam.find(:first, 
              :conditions => ["quality_id = ? and grade = ?", @unseen_quality3.id, "B"])
            @pamc = Pam.find(:first, 
              :conditions => ["quality_id = ? and grade = ?", @unseen_quality3.id, "C"])                     
            @pamd = Pam.find(:first, 
              :conditions => ["quality_id = ? and grade = ?", @unseen_quality3.id, "D"])
            @pame = Pam.find(:first, 
              :conditions => ["quality_id = ? and grade = ?", @unseen_quality3.id, "E"])
            @wrong_pam = Pam.find(:first, 
              :conditions => ["quality_id = ? and grade = ?", @unseen_quality2.id, "A"])
            @wrong_pam.update_attribute(:descriptor, "wrong")
            @pams = [@pama, @pamb, @pamc, @pamd, @pame]
          end
                    
          it "should show the attribute's grades" do
            get :show, :id => @unseen_quality3.id
            response.should have_selector("td", :content => @pama.descriptor)
            response.should have_selector("td", :content => @pamb.descriptor)
          end
          
          it "should not show grades for different attributes" do
            get :show, :id => @unseen_quality3.id
            response.should_not have_selector("td", :content => @wrong_pam.descriptor)
          end 
          
          it "should have an 'edit' link for each descriptor" do
            get :show, :id => @unseen_quality3.id
            @pams.each do |pam|
              response.should have_selector("a", :href => edit_submitted_pam_path(pam))
            end
          end
        end
      end  
    end
    
    describe "GET 'edit'" do
      
      describe "if the attribute has already been approved" do
      
        it "should not be successful" do
          get :edit, :id => @quality1.id
          response.should_not be_success
        end
      
      end
      
      describe "if the attribute has been rejected" do
      
        it "should not be successful" do
          get :edit, :id => @removed_quality.id
          response.should_not be_success
        end
        
      end
      
      describe "if the attribute was created by another user" do
      
        it "should not be successful" do
          get :edit, :id => @other_user_submission.id
          response.should_not be_success
        end
      end
      
      describe "if attribute submitted by current user has not been approved" do
      
        it "should be successful" do
          get :edit, :id => @unseen_quality1.id
          response.should be_success
        end
        
        it "should have the right title" do
          get :edit, :id => @unseen_quality1.id
          response.should have_selector("title", :content => "Edit attribute submission")
        end
      
        it "should have a 'Cancel' button, returning to the submitted Qualities show page" do
          get :edit, :id => @unseen_quality1.id
          response.should have_selector("a", :href => submitted_quality_path(@unseen_quality1),
      					:content => "Cancel")
        end
        
        it "should have a 'confirm changes' button" do
          get :edit, :id => @unseen_quality1.id
          response.should have_selector("input", 
                    :type => "submit", 
                    :value => "Confirm")
        end
        
        it "should have an edit box for the attribute" do
          get :edit, :id => @unseen_quality1.id
          response.should have_selector("input", 
                    :name => "quality[quality]")
        end
        
        it "should have a hidden field for 'updated_by'" do
          get :edit, :id => @unseen_quality1.id
          response.should have_selector("input",
        		:name => "quality[updated_by]",
        		:type => "hidden")
        end
    
      end
      
    end
    
    describe "PUT 'update'" do
    
      describe "when validation fails" do
      
        before(:each) do
          @attr = { :quality => "" }
        end
        
        it "should not change the number of qualities" do
          lambda do
            put :update, :id => @unseen_quality1, :quality => @attr
          end.should_not change(Quality, :count)
        end
            
        it "should render the 'edit' page" do
          put :update, :id => @unseen_quality1, :quality => @attr
          response.should render_template('edit')
        end

        it "should have the right title" do
          put :update, :id => @unseen_quality1, :quality => @attr
          response.should have_selector("title", 
                  :content => "Edit attribute submission")
        end
        
        it "should not change the quality's attributes" do
          put :update, :id => @unseen_quality1, :quality => @attr
          @unseen_quality1.reload
          @unseen_quality1.quality.should_not  == ""
          @unseen_quality1.removed.should == false
        end
      end
      
      describe "when validation passes" do 
      
        before(:each) do
          @attr = { :quality => "Changed attribute" }
        end
      
        describe "if the attribute has already been approved" do
      
          it "should not change the quality's attributes" do
            put :update, :id => @quality1, :quality => @attr
            @quality1.reload
            @quality1.quality.should_not == "Changed attribute"
          end
          
          it "should redirect to the root path" do
            put :update, :id => @quality1, :quality => @attr
            response.should redirect_to root_path
          end
          
          it "should flash an explanatory message" do
            put :update, :id => @quality1, :quality => @attr
            flash[:notice].should =~ /already been approved./i
          end
      
        end
      
        describe "if the attribute has been rejected" do
      
          it "should not change the quality's attributes" do
            put :update, :id => @removed_quality, :quality => @attr
            @removed_quality.reload
            @removed_quality.quality.should_not == "Changed attribute"
          end
        
        end
      
        describe "if the attribute was created by another user" do
      
          it "should not change the quality's attributes" do
            put :update, :id => @other_user_submission, :quality => @attr
            @other_user_submission.reload
            @other_user_submission.quality.should_not == "Changed attribute"
          end
        end
      
        describe "if attribute submitted by current user has not been approved" do
      
          it "should not change the number of qualities" do
            lambda do
              put :update, :id => @unseen_quality1, :quality => @attr
            end.should_not change(Quality, :count)
          end

          it "should change the quality's attributes" do
            put :update, :id => @unseen_quality1, :quality => @attr
            @unseen_quality1.reload
            @unseen_quality1.quality.should  == "Changed attribute"
            @unseen_quality1.removed.should == false
          end
            
          it "should save the current user as the last updater" do
            put :update, :id => @unseen_quality1, :quality => @attr
            @unseen_quality1.reload
            @unseen_quality1.updated_by.should  == @user.id
          end

          it "should redirect to the attributes list page" do
            put :update, :id => @unseen_quality1, :quality => @attr
            response.should redirect_to submitted_quality_path(@unseen_quality1)
          end

          it "should have a flash message" do
            put :update, :id => @unseen_quality1, :quality => @attr
            flash[:success].should == "'Changed attribute' updated."
          end
        end
      end
    end
  end
  
  describe "for signed-in admins" do

    before(:each) do
      @admin = Factory(:user, :admin => true, :email => "admin@example.com")
      test_sign_in(@admin)
    end
      
    describe "GET 'index'" do
      
      it "should be successful" do
        get 'index'
        response.should be_success
      end
      
      it "should have the right title" do
        get 'index'
        response.should have_selector("title", :content => "New attribute submissions")
      end
      
      it "should list all the unseen attributes" do
        get :index
        @qualities[5..6].each do |quality|
          response.should have_selector("td", :content => quality.quality)
        end
      end 
      
      it "should not list any seen but non-approved attributes" do
        get :index
        @qualities.each do |quality|
          response.should_not have_selector("td", 
                   :content => "Fourth quality")
        end
      end
    
      it "should not list any removed attributes" do
        get :index
        @qualities.each do |quality|
          response.should_not have_selector("td", 
                    :content => "Fifth quality")
        end
      end
      
      it "should not list any approved attributes" do
        get :index
        @qualities.each do |quality|
          response.should_not have_selector("td", 
                    :content => "Second quality")
        end
      end
      
      it "should have an edit button for each element" do
        get :index
        @qualities[5..5].each do |quality|
          response.should have_selector("a", 
                                     :href => edit_submitted_quality_path(quality))
        end
      end
      
      it "should have a delete button for each element" do
        get :index
        @qualities[5..6].each do |quality|
          response.should have_selector("a", 
                               :title => "Delete #{quality.quality}")
        end
      end
        
      it "should have a link to approved attributes" do
        get :index
        response.should have_selector("a", :href => qualities_path,
      			:content => "Approved list")
      end

    end
  end
  
  

end
