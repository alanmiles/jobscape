require 'spec_helper'

describe BusinessesController do

  render_views
  
  describe "for non-signed-in users" do
    
    before(:each) do
      @business = Factory(:business)
    end
      
    describe "GET 'index'" do
      
      it "should deny access" do
        get :index
        response.should redirect_to(signin_path)
        flash[:notice].should =~ /sign in/i
      end
  
    end
    
    describe "GET 'show'" do
    
      it "should deny access" do
        get :show, :id => @business
        response.should redirect_to(signin_path)
        flash[:notice].should =~ /sign in/i
      end   
    end
    
    describe "GET 'new'" do
      
      it "should deny access" do
        get :new
        response.should redirect_to(signin_path)
        flash[:notice].should =~ /sign in/i
      end
    
    end
    
    describe "DELETE 'destroy'" do
      it "should deny access" do
        delete :destroy, :id => @business
        response.should redirect_to(signin_path)
      end 
    end
    
  end
  
  describe "for signed-in admins" do
  
    before(:each) do
      @user = Factory(:user, :admin => true)
      test_sign_in(@user)
    end
  
  
    describe "GET 'index'" do
    
      before(:each) do
        @biz1 = Factory(:business)
        @biz2 = Factory(:business, :name => "Biz2", :address => "CB1 3TJ")
        @biz3 = Factory(:business, :name => "Biz3", :address => "CB1 3TJ") 
        @businesses = [@biz1, @biz2, @biz3]                          
      end
      
      it "should be successful" do
        get :index
        response.should be_success
      end
      
      it "should have the right title" do
        get :index
        response.should have_selector("title", :content => "Businesses")
      end
      
      it "should have an element for each business" do
        get :index
        @businesses[0..2].each do |business|
          response.should have_selector("td", :content => business.name)
        end
      end
      
      it "should count the total number of businesses" do
        get :index
        response.should have_selector(".r-float", :content => @businesses.count.to_s)
      end
    end
  
    describe "DELETE 'destroy'" do
    
      before(:each) do
        @business = Factory(:business)
      end
      
      it "should destroy the business" do
        lambda do
          delete :destroy, :id => @business
        end.should change(Business, :count).by(-1)
      end

      it "should redirect to the business index page" do
        delete :destroy, :id => @business
        response.should redirect_to(businesses_path)
      end
    end
    
  end
  
  describe "for signed-in non-admins" do
  
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end
    
    describe "GET 'index'" do
      it "should deny access" do
        get :index
        response.should redirect_to(root_path)
        flash[:notice].should =~ /available to administrators/i
      end
    end

    describe "GET 'show'" do
    
      before(:each) do
        @business = Factory(:business)
      end
      
      it "should have the right title" do
        get :show, :id => @business
        response.should have_selector("title", :content => "Business")
      end
      
      it "should have an edit link" do
        get :show, :id => @business
        response.should have_selector("a", :href => edit_business_path(@business))
      end
      
      it "should display the city and country" do
        get :show, :id => @business
        response.should have_selector("p", :content => @business.city)
        response.should have_selector("p", :content => @business.country)
      end
    end
    
    
    describe "GET 'new'" do
      it "should be successful" do
        get :new
        response.should be_success
      end
      
      it "should have the right title" do
        get :new
        response.should have_selector("title", :content => "New business")
      end
    end
    
    describe "POST 'create'" do

      describe "failure" do

        before(:each) do
        
          @attr = { :name => "", :address => "" }
        end

        it "should not create a business" do
          lambda do
            post :create, :business => @attr
          end.should_not change(Business, :count)
        end

        it "should have the right title" do
          post :create, :business => @attr
          response.should have_selector("title", :content => "New business")
        end

        it "should render the 'new' page" do
          post :create, :business => @attr
          response.should render_template('new')
        end
        
      end
    
      describe "success" do

        before(:each) do
          @name = "Some business"
          @attr = { :name => @name, :address => "TN9 1SP" }
        end

        it "should create a business" do
          lambda do
            post :create, :business => @attr
          end.should change(Business, :count).by(1)
        end

        it "should redirect to the business show page" do
          post :create, :business => @attr
          response.should redirect_to(business_path(assigns(:business)))
        end
              
        it "should have a success message" do
          post :create, :business => @attr
          flash[:success].should == @name + " added."
        end
        
        it "should add the city field" do
          post :create, :business => @attr
          @business = assigns(:business)
          #@business.reload
          @business.city.should == "Tonbridge"
        end
        
        it "should create an Employee record, linking business and user" do
          post :create, :business => @attr
          @business = assigns(:business)
          @employee = Employee.find(:first, 
           		:conditions => ["user_id = ? and business_id = ?", 
           		@user.id, @business.id])
          @employee.should be_valid
        end    
        
      end     
        
    end
   
    describe "GET 'edit'" do
    
      before(:each) do
        @business = Factory(:business)
      end
      
      it "should be successful" do
        get :edit, :id => @business
        response.should be_success
      end

      it "should have the right title" do
        get :edit, :id => @business
        response.should have_selector("title", :content => "Edit business")
      end
      
      it "should have a 'Cancel' option, redirecting to the show page" do
        get :edit, :id => @business
        response.should have_selector("a", :href => business_path(@business),
                                           :content => "Cancel")
      end
    end
    
    describe "PUT 'update'" do
    
      before(:each) do
        @business = Factory(:business)
      end
      
      describe "failed validation" do
      
        before(:each) do
          @attr = { :name => "", :address => "" }
        end
        
        it "should display an error message" do
          put :update, :id => @business, :business => @attr
          response.should have_selector("div#error_explanation")
        end
        
        it "should render the edit page" do
          put :update, :id => @business, :business => @attr
          response.should render_template('edit')
        end
        
        it "should have the right title" do
          put :update, :id => @business, :business => @attr
          response.should have_selector("title", :content => "Edit business")
        end
      
      end
      
      describe "success" do
      
        before(:each) do
          @new_address = "TN9 1SP"
          @attr = { :address => @new_address }
        end
        
        it "should successfully change the address and city attributes" do
          put :update, :id => @business, :business => @attr
          @business.reload
          @business.address.should == @new_address
          @business.city.should == "Tonbridge"
        end
        
        it "should automatically update latitude and longitude" do
          @lat = @business.latitude
          put :update, :id => @business, :business => @attr
          @business.reload
          @business.latitude.should_not == @lat
        end
        
        it "should have a success message" do
          put :update, :id => @business, :business => @attr
          flash[:success].should == "Business details updated."
        end
        
        it "should display the Show page" do
          put :update, :id => @business, :business => @attr
          response.should redirect_to @business
        end
      end
    
    end
  end
end
