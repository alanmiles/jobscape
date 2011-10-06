require 'spec_helper'

describe AttributeRejectionsController do

  before(:each) do
    @sector = Factory(:sector)
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

end
