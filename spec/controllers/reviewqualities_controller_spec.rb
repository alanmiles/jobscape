require 'spec_helper'

describe ReviewqualitiesController do

  describe "GET 'edit'" do
    it "should be successful" do
      get 'edit'
      response.should be_success
    end
  end

end
