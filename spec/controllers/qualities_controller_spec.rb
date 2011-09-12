require 'spec_helper'

describe QualitiesController do

  render_views
  
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

  describe "for signed-in users, with a business selected" do
  
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
    
      it "should have a hidden field for the business id" do
        get :new
        response.should have_selector("input", 
      			:name => "quality[business_id]",
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
          @attr = { :quality => "First quality",
          	    :created_by => @user.id,
          	    :business_id => @business.id }
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
          
        it "should set the business_id" do
          post :create, :quality => @attr
          @quality = assigns(:quality)
          @quality.should respond_to(:business_id)
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
  
  describe "for signed-in non-admins with no business selected" do
  
    before(:each) do
      @nobiz_user = Factory(:user)
      test_sign_in(@nobiz_user)
    end
    
    describe "GET 'new'" do
    
      it "should not be successful" do
        get :new
        response.should_not be_success
      end
      
      it "should redirect to the business_select page" do
        get :new
        response.should redirect_to select_business_path
      end
    end
    
    describe "POST 'create'" do
    
      before(:each) do
        @attr = { :quality => "First quality",
          	    :created_by => @nobiz_user.id,
          	    :business_id => 1 }
      end
      
      it "should not create a new attribute" do
        lambda do
          post :create, :quality => @attr
          response.should_not change(Quality, :count)
        end
      end
        
      #Personal Attribute Measurements
      it "should not generate a related set of empty PAMs"
           
      it "should redirect to the business-selection page" do
        post :create, :quality => @attr
        response.should redirect_to select_business_path   
      end
            
      it "should display an explanatory flash message" do
        post :create, :quality => @attr
        flash[:notice] = "Illegal procedure. You must select a business 
           and use the buttons provided before you can create a new
           attribute."    
      end
    
    end
  
  end
  
  describe "for signed-in admins" do
  
    before(:each) do
      @admin_user = Factory(:user, :admin => true)
      test_sign_in(@admin_user)
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
          
        it "should not set the business_id" do
          post :create, :quality => @attr
          @quality = assigns(:quality)
          @quality.business_id.should == nil
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
  
  end

end
