require 'spec_helper'

describe PagesController do
  render_views

  before :each do
    @base_title = "JobScape"
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
  end
  
  describe "signed in as a non-admin non-officer" do
  
    before(:each) do
      @user = Factory(:user)
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
        response.should have_selector("h1", :content => @user.name) 
      end
    
      describe "when user is not attached to a business" do
        
        it "should state that there are no business connections" do
          get :user_home
          response.should have_selector("p", 
              :content => "WHERE DO YOU WANT TO START?")
        end
        
        it "should not have a button to create a new business" do
          get :user_home
          response.should_not have_selector("a", 
                             :href => new_business_path)
        end
      end
    
      describe "when user is connected to one business as an officer" do
        
        before(:each) do
          @business = Factory(:business)
          @employee = Factory(:employee, :user_id => @user.id,
                                       :business_id => @business.id,
                                       :officer =>  true )             
        end
        
        it "should display the business" do
          get :user_home
          response.should have_selector("h4", 
            :content => "#{@business.name}, #{@business.city}, #{@business.country}")
        end
        
        it "should have an 'OFFICER MENU' title" do
          get :user_home
          response.should have_selector("p", :content => "OFFICER MENU")
        end
        
        
      end
    
      describe "when user is connected to one business as an employee" do
        
        before(:each) do
          @business = Factory(:business)
          @employee = Factory(:employee, :user_id => @user.id,
                                       :business_id => @business.id,
                                       :officer => false)
        end
        
        it "should display the business" do
          get :user_home
          response.should have_selector("h4", 
            :content => "#{@business.name}, #{@business.city}, #{@business.country}")
        end
        
        it "should have an 'EMPLOYEE MENU' title" do
          get :user_home
          response.should have_selector("p", :content => "EMPLOYEE MENU")
        end
      end
       
      describe "when user is connected to multiple businesses" do
    
        before(:each) do
          @business_1 = Factory(:business)
          @business_2 = Factory(:business, :name => "Business_2")
          @business_3 = Factory(:business, :name => "Business_3")
          @employee_1 = Factory(:employee, :user_id => @user.id,
       			:business_id => @business_1.id, :officer => true)
       	  @employee_2 = Factory(:employee, :user_id => @user.id,
       				:business_id => @business_2.id)
       	  @user_3 = Factory(:user, :email => "user3@email.com")
       	  @employee_3 = Factory(:employee, :user_id => @user_3.id,
       			:business_id => @business_3.id, :officer => false)
          @employees = [@employee_1, @employee_2, @employee_3]
        end
        
        it "should show all associated businesses for the current user" do
          get :user_home
          @employees[0..1].each do |employee|
            response.should have_selector("td", 
               :content => employee.business.name)
          end
        end
        
        it "should show the correct officer value for each business" do
          get :user_home
          @employees[0..1].each do |employee|
            if employee.officer?
              response.should have_selector("td", :content => "Officer")
            else
              response.should have_selector("td", :content => "Employee")
            end 
          end
        end
        
        it "should exclude non-associated businesses or users" do
          get :user_home
          @employees.each do |employee|
            response.should_not have_selector("td", 
               :content => @business_3.name)
          end
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
