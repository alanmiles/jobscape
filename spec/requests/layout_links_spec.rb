require 'spec_helper'

describe "LayoutLinks" do

  it "should have a Home page at '/'" do
    get '/'
    response.should have_selector('title', :content => "Home")
  end

  it "should have a Contact page at '/contact'" do
    get '/contact'
    response.should have_selector('title', :content => "Contact")
  end

  it "should have an About page at '/about'" do
    get '/about'
    response.should have_selector('title', :content => "About")
  end
  
  it "should have a Help page at '/help'" do
    get '/help'
    response.should have_selector('title', :content => "Help")
  end
  
  it "should have a signup page at '/signup'" do
    get '/signup'
    response.should have_selector('title', :content => "Sign up")
  end
  
  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    response.should have_selector('title', :content => "About")
    #click_link "Click to toggle Help on/off"
    #response.should have_selector('title', :content => "Help")
    click_link "Contact"
    response.should have_selector('title', :content => "Contact")
    click_link "Home"
    response.should have_selector('title', :content => "Home")
    click_link "Sign up now!"
    response.should have_selector('title', :content => "Sign up")
  end
  
  describe "when not signed in" do
    it "should have a signin link" do
      visit root_path
      response.should have_selector("a", :href => signin_path)
    end
  end

  describe "when signed in" do

    before(:each) do
      @sector = Factory(:sector)
      @user = Factory(:user, :address => "Tonbridge")
      visit signin_path
      fill_in :email,    :with => @user.email
      fill_in :password, :with => @user.password
      click_button
    end

    it "should direct to the user home page" do
      visit root_path
      response.should have_selector("title", :content => "User Home")
    end

    it "should have a signout link" do
      visit root_path
      response.should have_selector("a", :href => signout_path)
    end

    it "should have a self-portrait link" do
      visit root_path
      response.should have_selector("a", :href => user_portrait_path(@user),
                                         :content => "Self-Portrait")
    end
  end
  
  describe "when signed in as an administrator" do
  
    before(:each) do
      @sector = Factory(:sector)
      @user = Factory(:user, :admin => true)
      visit signin_path
      fill_in :email,    :with => @user.email
      fill_in :password, :with => @user.password
      click_button
    end
    
    it "should direct to the Admin Menu page" do
      visit root_path
      response.should have_selector("title", :content => "Admin")
    end
   
  end
end

