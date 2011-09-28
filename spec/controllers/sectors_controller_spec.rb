require 'spec_helper'

describe SectorsController do

  describe "for non-signed-in users" do
  
    describe "GET 'index'" do
      it "should not be successful" do
        get :index
        response.should_not be_success
      end
    end

    describe "GET 'new'" do
      it "should not be successful" do
        get :new
        response.should_not be_success
      end
    end

  end
  
  describe "for signed-in non-admins" do
  
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end
    
    describe "GET 'index'" do
      it "should not be successful" do
        get :index
        response.should_not be_success
      end
    end

    describe "GET 'new'" do
      it "should not be successful" do
        get :new
        response.should_not be_success
      end
    end
    
  end
  
  describe "for signed-in admins" do
  
    before(:each) do
      @admin = Factory(:user, :admin => true)
      test_sign_in(@admin)
    end
    
    describe "GET 'index'" do
      it "should be successful" do
        get :index
        response.should be_success
      end
    end

    describe "GET 'new'" do
      it "should be successful" do
        get :new
        response.should be_success
      end
    end
    
  end
end
