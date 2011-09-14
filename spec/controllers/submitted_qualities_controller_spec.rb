require 'spec_helper'

describe SubmittedQualitiesController do
  
  render_views
  
  before(:each) do
    @quality1 = Factory(:quality, :approved => true)
    @quality2 = Factory(:quality, :quality => "Second quality", :approved => true) 
    @quality3 = Factory(:quality, :quality => "Third quality", :approved => true)
    @unapproved_quality = Factory(:quality, :quality => "Fourth quality", 
    					:seen => true)
    @removed_quality = Factory(:quality, :quality => "Fifth quality", 
                               :approved => true, :removed => true)
    @unseen_quality1 = Factory(:quality, :quality => "Sixth quality")
    @unseen_quality2 = Factory(:quality, :quality => "Seventh quality")
    
    @qualities = [@quality1, @quality2, @quality3, @unapproved_quality, @removed_quality, @unseen_quality1, @unseen_quality2]
  end
  
  describe "for non-signed-in users" do
    
    describe "GET 'index'" do
      
      it "should not be successful" do
        get 'index'
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
        get 'index'
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
        get 'index'
        response.should be_success
      end
      
      it "should have the right title" do
        get 'index'
        response.should have_selector("title", :content => "New attribute submissions")
      end
      
      it "should list all the unseen attributes" do
        get :index
        @qualities[5..6].each do |quality|
          response.should have_selector("td", :content => quality.quality)
        end
      end 
      
      it "should not list any seen but non-approved attributes" do
        get :index
        @qualities.each do |quality|
          response.should_not have_selector("td", 
                   :content => "Fourth quality")
        end
      end
    
      it "should not list any removed attributes" do
        get :index
        @qualities.each do |quality|
          response.should_not have_selector("td", 
                    :content => "Fifth quality")
        end
      end
      
      it "should not list any approved attributes" do
        get :index
        @qualities.each do |quality|
          response.should_not have_selector("td", 
                    :content => "Second quality")
        end
      end
      
      it "should have an edit button for each element" do
        get :index
        @qualities[5..5].each do |quality|
          response.should have_selector("a", 
                                     :href => edit_submitted_quality_path(quality))
        end
      end
      
      it "should have a delete button for each element" do
        get :index
        @qualities[5..6].each do |quality|
          response.should have_selector("a", 
                               :title => "Delete #{quality.quality}")
        end
      end
        
      it "should have a link to approved attributes" do
        get :index
        response.should have_selector("a", :href => qualities_path,
      			:content => "Approved list")
      end

    end
  end
  
  

end
