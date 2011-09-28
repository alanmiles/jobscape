require 'spec_helper'

describe Officer::BusinessesController do

  render_views
  
  before(:each) do
    @sector = Factory(:sector)
    @business = Factory(:business, :sector_id => @sector.id)
    @user = Factory(:user)
    @employee = Factory(:employee, :business_id => @business.id,
                      :user_id => @user.id, :officer => true)
      
  end
  
  describe "for non-signed-in users" do
  
    describe "DELETE 'destroy'" do
    
      it "should not destroy the business"

    end    
     
  end
  
  describe "for non-signed-in employees" do
  
    describe "DELETE 'destroy'" do
    
      it "should not destroy the business"

    end   
  end
  
  describe "for signed-in officers" do
  
    before(:each) do
      test_sign_in(@user)
    end
    
    describe "DELETE 'destroy'" do
    
      it "should destroy the business"

    end   
  end
end
