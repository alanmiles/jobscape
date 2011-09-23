require 'spec_helper'

describe RequirementsController do

  before(:each) do
    @user = Factory(:user)
    @business = Factory(:business)
    @occupation = Factory(:occupation)
    @job = Factory(:job, :occupation_id => @occupation.id, :business_id => @business.id)
    @employee = Factory(:employee, :user_id => @user.id, :business_id => @business.id)
    session[:jobid] = @job.id
    @plan = Plan.find_by_job_id(@job.id)
    
    test_sign_in(@user)
  end
  
  describe "GET 'index'" do
    it "should be successful" do
      get :index, :id => @plan
      response.should be_success
    end
  end

  describe "GET 'new'" do
    it "should be successful" do
      get :new, :id => @plan
      response.should be_success
    end
  end

end
