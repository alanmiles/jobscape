require 'spec_helper'

describe "BusinessCreations" do
  
  before(:each) do
    @user = Factory(:user)
    integration_sign_in(@user)
  end
  
  describe "correctly filled and recognized geolocation" do
    
    it "should create the business and return to the businesses list" do
      lambda do
        visit new_business_path
        fill_in "Name",         :with => "Test"
        fill_in "UK post-code", :with => "TN9 1SP"
        click_button
        response.should render_template('businesses')
        #response.should render_template('businesses/1/edit')
        #response.should have_selector("div#error_explanation")
      end.should change(Business, :count).by(1)
    end     
  end
  
  describe "incorrectly filled details" do
      
    it "should not create the business and display the 'new' form" do
      lambda do
        visit new_business_path
        fill_in "Name",         :with => ""
        fill_in "UK post-code", :with => "TN9 1SP"
        click_button
        response.should have_selector("div#error_explanation")
        response.should have_selector("title", :content => "New business")
        response.should render_template('businesses/new')
      end.should_not change(Business, :count)
    
    end
  
  end
  
  describe "unidentified geolocation" do
      
    it "should create the business but force 'address' to be reentered" do
      lambda do
        visit new_business_path
        fill_in "Name",         :with => "Good Jobs"
        fill_in "UK post-code", :with => "XX91SPvv123g"
        click_button
        #response.should have_selector("div#error_explanation")
        response.should have_selector("title", :content => "Edit business")
        response.should render_template('businesses/edit')
      end.should change(Business, :count).by(1)
     
    end
  
  end
  
end
