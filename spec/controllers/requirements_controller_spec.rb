require 'spec_helper'

describe RequirementsController do

  render_views
  
  before(:each) do
    @sector = Factory(:sector)
    @user = Factory(:user)
    @business = Factory(:business, :sector_id => @sector.id)
    @occupation = Factory(:occupation)
    @job = Factory(:job, :occupation_id => @occupation.id, :business_id => @business.id)
    @employee = Factory(:employee, :user_id => @user.id, :business_id => @business.id)
    session[:jobid] = @job.id
    @plan = Plan.find_by_job_id(@job.id)
  end
  
  describe "for non-signed-in users" do
    
    describe "GET 'index'" do
      it "should not be successful" do
        get :index, :plan_id => @plan.id
        response.should_not be_success
      end
    end

    describe "GET 'new'" do
      it "should not be successful" do
        get :new, :plan_id => @plan.id
        response.should_not be_success
      end
    end
    
  end
  
  describe "for signed-in users" do
    
    before(:each) do
      test_sign_in(@user)
    end
    
    describe "GET 'index'" do
      it "should be successful" do
        get :index, :plan_id => @plan.id
        response.should be_success
      end
    end

    describe "GET 'new'" do
      it "should be successful" do
        get :new, :plan_id => @plan.id
        response.should be_success
      end
    end
  end
end
