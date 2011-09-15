require 'spec_helper'

describe QualitiesController do

  render_views
  
  before(:each) do
    @quality1 = Factory(:quality, :approved => true)
    @quality2 = Factory(:quality, :quality => "Second quality", :approved => true) 
    @quality3 = Factory(:quality, :quality => "Third quality", :approved => true)
    @unapproved_quality = Factory(:quality, :quality => "Fourth quality", :seen => true)
    @removed_quality = Factory(:quality, :quality => "Fifth quality", 
                               :approved => true, :removed => true)
    @unseen_quality = Factory(:quality, :quality => "Sixth quality")
    
    @qualities = [@quality1, @quality2, @quality3, @unapproved_quality, @removed_quality, @unseen_quality]
  end
  
  describe "GET 'index'" do
    it "should be successful" do
      get :index
      response.should be_success
    end
    
    it "should have the correct title" do
      get :index
      response.should have_selector("title", :content => "Personal Attributes")
    end
    
    it "should have a link to the 'new' page" do
      get :index
      response.should have_selector("a", :href => new_quality_path,
      			:content => "Add an attribute")
    end
    
  end
  
  describe "for non-signed-in users" do
  
    describe "GET 'index'" do
    
      it "should list all the admin-approved attributes" do
        get :index
        @qualities[0..2].each do |quality|
          response.should have_selector("td", :content => quality.quality)
        end
      end 
      
      it "should not list any non-approved attributes" do
        get :index
        @qualities.each do |quality|
          response.should_not have_selector("td", :content => "Fourth quality")
        end
      end
    
      it "should not list any removed attributes" do
        get :index
        @qualities.each do |quality|
          response.should_not have_selector("td", :content => "Fifth quality")
        end
      end
      
    end
    
    describe "GET 'new'" do
    
      it "should not be successful" do
        get :new
        response.should_not be_success
      end
      
      it "should redirect to the signin page" do
        get :new
        response.should redirect_to signin_path
      end
    end
  
  end

  describe "for signed-in non-admin users" do
  
    before(:each) do
      @business = Factory(:business)
      session[:biz] = @business.id
      @user = Factory(:user)
      @employee = Factory(:employee, :business_id => @business.id,
      			:user_id => @user.id)
      test_sign_in(@user)
    end
    
    describe "GET 'new'" do
      it "should be successful" do
        get :new
        response.should be_success
      end
    
      it "should have the right title" do
        get :new
        response.should have_selector("title", :content => "New Personal Attribute")
      end
    
      it "should have a 'Cancel' button, returning to the Qualities list" do
        get :new
        response.should have_selector("a", :href => qualities_path,
      					:content => "Cancel")
      end
    
      it "should have a text field for the attribute name" do
        get :new
        response.should have_selector("input", 
      			:name => "quality[quality]")
      end
    
      it "should have a hidden field for the creator" do
        get :new
        response.should have_selector("input", 
      			:name => "quality[created_by]",
      			:type => "hidden")
      end
    
      it "should have a 'Create' button" do
        get :new
        response.should have_selector("input", 
            	    :type => "submit", 
                    :value => "Create")
    
      end
    end
    
    describe "POST 'create'" do
    
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
                   :content => "New Personal Attribute")
        end
        
        it "should render the 'new' page" do
          post :create, :quality => @attr
          response.should render_template('new')
        end
        
      end
      
      describe "success" do
      
        before(:each) do
          @attr = { :quality => "Another quality",
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
        
        it "should redirect to the 'show' page" do
          post :create, :quality => @attr
          response.should redirect_to(quality_path(assigns(:quality)))
        end
        
        it "should generate a flash guidance message" do
          post :create, :quality => @attr
          @quality = assigns(:quality)
          flash[:success].should == "#{@quality.quality} added. Now set the 5 PAMs."
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
      end
    end
  end
  
  describe "for signed-in admins" do
  
    before(:each) do
      @admin_user = Factory(:user, :admin => true)
      test_sign_in(@admin_user)
    end
  
    describe "GET 'index'" do
    
      it "should be successful" do
        get :index
        response.should be_success
      end
    
      it "should have the correct title" do
        get :index
        response.should have_selector("title", 
                    :content => "Personal Attributes")
      end
    
      it "should have a link to the 'new' page" do
        get :index
        response.should have_selector("a", :href => new_quality_path,
      			:content => "Add an attribute")
      end
    
      describe "official approved list" do
      
        it "should list all the admin-approved attributes" do
          get :index
          @qualities[0..2].each do |quality|
            response.should have_selector("td", :content => quality.quality)
          end
        end 
      
        it "should not list any non-approved attributes" do
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
        
        it "should have a 'show' link for each attribute" do
          get :index
          @qualities[0..2].each do |quality|
            response.should have_selector("a", 
                    :href => quality_path(quality))
          end
        end
      
        it "should have an edit button for each element" do
          get :index
          @qualities[0..2].each do |quality|
            response.should have_selector("a", 
                                       :href => edit_quality_path(quality))
          end
        end
      
        it "should have a Remove button for each element" do
          get :index
          @qualities[0..2].each do |quality|
            response.should have_selector("a", 
                                 :title => "Remove #{quality.quality}")
          end
        end
        
        it "should have a link to unseen attributes" do
          get :index
          response.should have_selector("a", :href => submitted_qualities_path,
      					:content => "New submissions")
        end
        
        it "should count the number of unseen submissions" do
          get :index
          response.should have_selector("span#submits",
      					:content => "(1)")
        end
      end
      
    end
    
    describe "GET 'new'" do
      it "should be successful" do
        get :new
        response.should be_success
      end
    
      it "should have the right title" do
        get :new
        response.should have_selector("title", 
                      :content => "New Personal Attribute")
      end
    
      it "should have a 'Cancel' button, returning to the Qualities list" do
        get :new
        response.should have_selector("a", :href => qualities_path,
      					:content => "Cancel")
      end
    
      it "should have a text field for the attribute name" do
        get :new
        response.should have_selector("input", 
      			:name => "quality[quality]")
      end
    
      it "should have a hidden field for the creator" do
        get :new
        response.should have_selector("input", 
      			:name => "quality[created_by]",
      			:type => "hidden")
      end
    
      it "should have a 'Create' button" do
        get :new
        response.should have_selector("input", 
            	    :type => "submit", 
                    :value => "Create")
    
      end
    end
  
    describe "POST 'create'" do
      
      describe "failure" do
      
        before(:each) do
          @attr = { :quality => "" }
        end
             
        it "should not create a new quality" do
          lambda do
            post :create, :quality => @attr
            response.should_not change(Quality, :count)
          end
        end
        
        it "should have the correct title" do
          post :create, :quality => @attr
          response.should have_selector("title", 
                   :content => "New Personal Attribute")
        end
        
        it "should render the 'new' page" do
          post :create, :quality => @attr
          response.should render_template('new')
        end
      
      end
      
      
      describe "success" do
      
        before(:each) do
          @attr = { :quality => "Good attribute", 
                    :created_by => @admin_user.id }
        end
        
        it "should create a new attribute" do
          lambda do
            post :create, :quality => @attr
            response.should change(Quality, :count).by(1)
          end
        end
        
        #Personal Attribute Measurements
        it "should generate a related set of empty PAMs"
        
        it "should redirect to the 'show' page" do
          post :create, :quality => @attr
          response.should redirect_to(quality_path(assigns(:quality)))
        end
        
        it "should generate a flash guidance message" do
          post :create, :quality => @attr
          @quality = assigns(:quality)
          flash[:success].should == "#{@quality.quality} added. Now set the 5 PAMs."
        end
          
        it "should set 'approved' to true" do
          post :create, :quality => @attr
          @quality = assigns(:quality)
          @quality.approved.should == true
        end
          
        it "should set 'seen' to true" do
          post :create, :quality => @attr
          @quality = assigns(:quality)
          @quality.seen.should == true
        end
          #maybe set to false when there are more admins
            
      end    
    end
    
    describe "GET 'edit'" do
      
      describe "already approved" do
      
        it "should be successful" do
          get :edit, :id => @quality1.id
          response.should be_success
        end
        
        it "should have the right title" do
          get :edit, :id => @quality1.id
          response.should have_selector("title", :content => "Edit attribute")
        end
      
        it "should have a 'Cancel' button, returning to the Qualities show page" do
          get :edit, :id => @quality1.id
          response.should have_selector("a", :href => quality_path(@quality1),
      					:content => "Cancel")
        end
        
        it "should have a 'confirm changes' button" do
          get :edit, :id => @quality1.id
          response.should have_selector("input", 
                    :type => "submit", 
                    :value => "Confirm")
        end
        
        it "should have an edit box for the attribute" do
          get :edit, :id => @quality1.id
          response.should have_selector("input", 
                    :name => "quality[quality]")
        
        end
        
      end
      
      #describe "unseen" do
      
      #  it "should be successful" do
      #    get :edit, :id => @unseen_quality.id
      #    response.should be_success
      #  end
        
      #  it "should have the right title" do
      #    get :edit, :id => @unseen_quality.id
      #    response.should have_selector("title", :content => "Edit attribute")
      #  end
        
      #  it "should have a 'Cancel' button, returning to the unseen Qualities list" do
      #    get :edit, :id => @unseen_quality.id
      #    response.should have_selector("a", :href => submitted_qualities_path,
      #					:content => "Cancel")
      #  end
      #end
      
      #describe "seen but not approved" do
      
      #  it "should be successful" do
      #    get :edit, :id => @unapproved_quality.id
      #    response.should be_success
      #  end
        
      #  it "should have the right title" do
      #    get :edit, :id => @unapproved_quality.id
      #    response.should have_selector("title", :content => "Edit attribute")
      #  end
        
      #  it "should have a 'Cancel' button, returning to the unapproved Qualities list" do
      #    get :edit, :id => @_unapproved_quality.id
      #    response.should have_selector("a", :href => rejected_qualities_path,
      #					:content => "Cancel")
      #  end
      #end
      
      #describe "removed" do
      
      #  it "should be successful" do
      #    get :edit, :id => @removed_quality.id
      #    response.should be_success
      #  end
      
      #  it "should have the right title" do
      #    get :edit, :id => @removed_quality.id
      #    response.should have_selector("title", :content => "Edit attribute")
      #  end
        
     #   it "should have a 'Cancel' button, returning to the removed Qualities list" do
      #    get :edit, :id => @removed_quality.id
      #    response.should have_selector("a", :href => removed_qualities_path,
      #					:content => "Cancel")
      #  end
      #end
        
    end
    
    describe "PUT 'update'" do
    
      describe "failure" do
      
        before(:each) do
          @attr = { :quality => ""}
        end
        
        it "should not change the number of qualities" do
          lambda do
            put :update, :id => @quality1, :quality => @attr
          end.should_not change(Quality, :count)
        end
            
        it "should render the 'edit' page" do
          put :update, :id => @quality1, :quality => @attr
          response.should render_template('edit')
        end

        it "should have the right title" do
          put :update, :id => @quality1, :quality => @attr
          response.should have_selector("title", 
                  :content => "Edit attribute")
        end
        
        it "should not change the goal's attributes" do
          put :update, :id => @quality1, :quality => @attr
          @quality1.reload
          @quality1.quality.should_not  == ""
          @quality1.removed.should == false
        end
          
      end
      
      describe "success" do
      
        before(:each) do
          @attr = { :quality => "Changed attribute",
                        :updated_by => @admin_user.id }
        end
            
        it "should not change the number of qualities" do
          lambda do
            put :update, :id => @quality1, :quality => @attr
          end.should_not change(Quality, :count)
        end

        it "should change the quality's attributes" do
          put :update, :id => @quality1, :quality => @attr
          @quality1.reload
          @quality1.quality.should  == @attr[:quality]
          @quality1.removed.should == false
        end
            
        it "should save the current user as the last updater" do
          put :update, :id => @quality1, :quality => @attr
          @quality1.reload
          @quality1.updated_by.should  == @admin_user.id
        end

        it "should redirect to the attributes list page" do
          put :update, :id => @quality1, :quality => @attr
          response.should redirect_to qualities_path
        end

        it "should have a flash message" do
          put :update, :id => @quality1, :quality => @attr
          flash[:success].should == "'Changed attribute' updated."
        end
      
      end
    
    end
    
    describe "GET 'show'" do
    
      it "should be successful" do
        get :show, :id => @quality1
        response.should be_success
      end
      
      it "should have the right title" do
        get :show, :id => @quality1
        response.should have_selector("title", :content => "Attribute: #{@quality1.quality}")
      end
      
      it "should have a link back to the attributes list" do
        get :show, :id => @quality1
        response.should have_selector("a", :href => qualities_path)
      end
      
      it "should have a link to the quality 'edit' page" do
        get :show, :id => @quality1
        response.should have_selector("a", :href => edit_quality_path(@quality1))
      end
    
      describe "showing the attribute's grades" do
          
        before(:each) do
          @pam_a = Pam.find(:first, :conditions => ["quality_id = ? and grade = ?", @quality1.id, "A"])
          @pam_b = Pam.find(:first, :conditions => ["quality_id = ? and grade = ?", @quality1.id, "B"])
          @pam_c = Pam.find(:first, :conditions => ["quality_id = ? and grade = ?", @quality1.id, "C"])                     
          @pam_d = Pam.find(:first, :conditions => ["quality_id = ? and grade = ?", @quality1.id, "D"])
          @pam_e = Pam.find(:first, :conditions => ["quality_id = ? and grade = ?", @quality1.id, "E"])
          @wrong_pam = Pam.find(:first, :conditions => ["quality_id = ? and grade = ?", @quality2.id, "A"])
          @wrong_pam.update_attribute(:descriptor, "wrong")
          @pams = [@pam_a, @pam_b, @pam_c, @Pam_d, @pam_e]
        end
                    
        it "should show the attribute's grades" do
          get :show, :id => @quality1.id
          response.should have_selector("td", :content => @pam_a.descriptor)
          response.should have_selector("td", :content => @pam_b.descriptor)
        end
          
        it "should not show grades for different attributes" do
          get :show, :id => @quality1.id
          response.should_not have_selector("td", :content => @wrong_pam.descriptor)
        end 
          
        it "should have an 'edit' link for each descriptor" do
          get :show, :id => @quality1.id
          @pams.each do |pam|
            response.should have_selector("a", :href => edit_pam_path(pam))
          end
        end
          
      end
    end
  
  end

end
