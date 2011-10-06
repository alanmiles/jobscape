require 'spec_helper'

describe OutlinesController do

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
    @outline = Outline.find_by_job_id(@job.id)
  end
  
  describe "for non-signed in users" do
  
    describe "GET 'show'" do
    
      it "should not be successful" do
        get :show, :id => @outline
        response.should_not be_success
      end
      
    end
  
  end
  
  describe "for signed-in users belonging to the correct business" do
  
    before(:each) do  
      test_sign_in(@user)
    end
    
    describe "GET 'show'" do
      it "should be successful" do
        get :show, :id => @outline
        response.should be_success
      end
    end

  end
end
