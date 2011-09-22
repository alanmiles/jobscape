class AttributeRejectionsController < ApplicationController
  
  before_filter :admin_user
  
  def index
    @title = "Rejected attributes"
    @qualities = Quality.rejected_list
    @submissions = Quality.new_submissions
  end
  
end
