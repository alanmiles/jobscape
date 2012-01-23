require 'spec_helper'

describe PagesController do
  render_views

  before :each do
    @base_title = "HYGWIT"
    @sector = Factory(:sector)
  end
  
  describe "GET 'home'" do
    it "should be successful" do
      get 'home'
      response.should be_success
    end
    
    it "should have the right title" do
      get 'home'
      response.should have_selector("title",
                        :content => @base_title + " | Home")
    end
  end

  describe "GET 'about'" do
    it "should be successful" do
      get 'about'
      response.should be_success
    end
    
    it "should have the right title" do
      get 'about'
      response.should have_selector("title",
                        :content => @base_title + " | About")
    end
  end
  
  describe "GET 'select_business'" do
  
    it "should not be successful" do
      get :select_business
      response.should_not be_success
    end
    
    it "should redirect to the signin path" do
      get :select_business
      response.should redirect_to signin_path
    end
  end
  
  describe "GET 'admin_home'" do
  
    it "should not be successful" do
      get :admin_home
      response.should_not be_success
    end
    
  end
  
  describe "GET 'user_home'" do
  
    it "should not be successful" do
      get :user_home
      response.should_not be_success
    end
  end
  
  describe "signed in as an admin" do
  
    before(:each) do
      @admin = Factory(:user, :admin => true)
      test_sign_in(@admin)
    end
    
    describe "GET 'admin_home'" do
    
      it "should be successful" do
        get :admin_home
        response.should be_success
      end
    
      it "should have the right title" do
        get :admin_home
        response.should have_selector("title",
                        :content => @base_title + " | Admin")
      end
    end
    
    describe "GET 'select_business'" do
    
      it "should be successful"  #when the session is admin_off
      #  get :select_business
      #  response.should_not be_success
      #end
    
    end
    
  end
  
  describe "signed in with an 'Individual' account" do
  
    before(:each) do
      @user = Factory(:user, :address => "Tonbridge")
      test_sign_in(@user)
    end
    
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              	  describe "GET 'user_home'" do
      
      it "should be successful" do
        get :user_home
        response.should be_success
      end
  
      it "should have the right title" do
        get :user_home
        response.should have_selector("title", 
                  :content => @base_title + " | User Home")
      end
      
      it "should include the user's name" do
        get :user_home
        response.should have_selector("h4", :content => @user.name) 
      end
    
      describe "when user is not attached to a business" do
        
        it "should have a button to create a new business" do
          get :user_home
          response.should have_selector("a", 
                             :href => new_business_path)
        end
      end
    
      describe "when user is connected to one business as an officer" do
      #THE FOLLOWING MAY NOW BE IRRELEVANT  
        
        before(:each) do
          @business = Factory(:business, :sector_id => @sector.id)
          @employee = Factory(:employee, :user_id => @user.id,
                                       :business_id => @business.id,
                                       :officer =>  true )            
        end
        
        it "should not display the 'User Home' page" 
          #get :user_home
          #response.should_not be_success
        #end
        
        it "should redirect to the Officer Home page"
        #  get :user_home
        #  response.should redirect_to officer_home_path
        #end
        
        it "should display the 'Officer Home' page" do
          session[:biz] = @business.id
          get :officer_home
          response.should be_success
        end
        
        #it "should display the current business" do
        #  get :officer_home
        #  response.should have_selector("h4", 
        #    :content => "#{@business.name}, #{@business.city}, #{@business.country}")
        #end
        
        #it "should have an 'OFFICER MENU' title" do
        #  get :officer_home
        #  response.should have_selector("p", :content => "OFFICER MENU")
        #end
        
        #it "should not display the 'Select Business' page" do
        #  get :select_business
        #  response.should_not be_success
        #  response.should redirect_to user_home_path
        #end
        
      end
    
      describe "when user is connected to one business as an employee" do
        
        before(:each) do
          @business = Factory(:business, :sector_id => @sector.id)
          @employee = Factory(:employee, :user_id => @user.id,
                                       :business_id => @business.id,
                                       :officer => false)
        end
        
        it "should display the business" 
        #  get :user_home
        #  response.should have_selector("h4", 
        #    :content => "EMPLOYEE MENU: #{@business.name}, #{@business.city}")
        #end
        
      end
       
      describe "when user is connected to multiple businesses" do
    
        before(:each) do
          #@sector = Factory(:sector)
          @business_1 = Factory(:business, :sector_id => @sector.id)
          @business_2 = Factory(:business, :name => "Business_2",
                                :sector_id => @sector.id)
          @business_3 = Factory(:business, :name => "Business_3",
                                :sector_id => @sector.id)
          @employee_1 = Factory(:employee, :user_id => @user.id,
       			:business_id => @business_1.id, :officer => true)
       	  @employee_2 = Factory(:employee, :user_id => @user.id,
       				:business_id => @business_2.id)
       	  @user_3 = Factory(:user, :email => "user3@email.com")
       	  @employee_3 = Factory(:employee, :user_id => @user_3.id,
       			:business_id => @business_3.id, :officer => false)
          @employees = [@employee_1, @employee_2, @employee_3]
        end
        
        it "should display the 'select business' form successfully" do
          get :select_business
          response.should be_success
        end 
       
        it "should have the right title" do
          get :select_business
          response.should have_selector("title", :content => "Select business")
        end
        
        it "should show all associated businesses for the current user" do
          get :select_business
          @employees[0..1].each do |employee|
            response.should have_selector("li", 
               :content => employee.business.name)
          end
        end
        
        it "should show the correct officer value for each business" do
          get :select_business
          @employees[0..1].each do |employee|
            if employee.officer?
              response.should have_selector("li", :content => "Officer")
            else
              response.should have_selector("li", :content => "Employee")
            end 
          end
        end
        
        it "should exclude non-associated businesses or users" do
          get :select_business
          @employees.each do |employee|
            response.should_not have_selector("td", 
               :content => @business_3.name)
          end
        end
        
        it "should have a nil value for session[:biz]" do
          get :select_business
          session[:biz].should == nil
        end
      end
    
     
    end
     
    describe "GET 'admin_home'" do
  
      it "should not be successful" do
        get :admin_home
        response.should_not be_success
      end
    
    end
    
  end
end
