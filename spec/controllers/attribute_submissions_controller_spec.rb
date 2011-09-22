require 'spec_helper'

describe AttributeSubmissionsController do

  render_views
  
  before(:each) do
    @admin = Factory(:user, :admin => true)
    @other_user = Factory(:user, :email => "other_user@example.com")
    test_sign_in(@admin)
  end
  
  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'edit'" do
  
    before(:each) do
      @quality = Factory(:quality, :created_by => @other_user.id)
    end
    
    it "should be successful" do
      get 'edit', :id => @quality
      response.should be_success
    end
  end

end
