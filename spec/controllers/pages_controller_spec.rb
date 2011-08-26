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
                  :content => @base_title + " | User Menu")
      end
      
      it "should include the user's name" do
        get :user_home
        response.should have_selector("h4", :content => @user.name) 
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
