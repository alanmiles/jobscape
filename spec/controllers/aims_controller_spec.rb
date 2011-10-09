require 'spec_helper'

describe AimsController do

  render_views
  
  before(:each) do
    @sector = Factory(:sector)
    @user = Factory(:user, :account => 2)
    @aim1 = @user.aims.build(:aim => "First aim", :position => 1)
    @aim2 = @user.aims.build(:aim => "Second aim", :position => 2)
    @aims = [@aim1, @aim2]
    test_sign_in(@user)  
  end
  
  describe "GET 'index'" do
    it "should be successful"
      #get :index, :user_id => @user.id
      #response.should be_success
    #end
  end

  describe "GET 'new'" do
    it "should be successful" 
    #  get :new, :user_id => @user.id
    #  response.should be_success
    #end
  end

  describe "GET 'edit'" do
    it "should be successful"
      #get :edit
      #response.should be_success
    #end
  end

end
