require 'spec_helper'

describe "Admins" do
  before(:each) do
    @user = Factory(:user, :admin => true)
    visit signin_path
    fill_in :email,    :with => @user.email
    fill_in :password, :with => @user.password
    click_button
  end
  
  it "should have a link to the occupations list" do
    click_link "Occupations"
    response.should have_selector("title", :content => "Occupations")
  end
end
