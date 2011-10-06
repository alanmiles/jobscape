require 'spec_helper'

describe "BusinessSelections" do
  
  before(:each) do
    @sector = Factory(:sector)
    @user = Factory(:user)
    @business1 = Factory(:business, :sector_id => @sector.id)
    @business2 = Factory(:business, :name => "Not Cambiz",
                         :sector_id => @sector.id)
    @employee1 = Factory(:employee, :user_id => @user.id, 
    				    :business_id => @business1.id,
    				    :officer => true)
    @employee2 = Factory(:employee, :user_id => @user.id, 
    				    :business_id => @business2.id,
    				    :officer => true)				     
    integration_sign_in(@user)
  end
  
  describe "business_selections" do
    
    it "should link to the correct business after selection" do
      visit select_business_path
      click_link "Not Cambiz, Cambridge"
      session[:biz].should == @business2.id
      response.should have_selector("title", :content => "Officer Home")  
    end

  end
end
