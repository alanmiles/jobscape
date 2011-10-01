require 'spec_helper'

describe VacanciesController do

  render_views
  
  describe "for non-signed-in users" do

    describe "GET 'new'" do
      it "should not be successful"
        #get 'new'
        #response.should be_success
      #end
    end

  end
  
  describe "for signed-in non-officers" do
  
  
  end
  
  describe "for signed-in admins" do
  
  end
  
  describe "for signed-in officers" do
  
  
  end
  
end
