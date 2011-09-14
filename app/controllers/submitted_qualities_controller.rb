class SubmittedQualitiesController < ApplicationController
  
  before_filter :authenticate
  before_filter :admin_user
  
  def index
    @title = "New attribute submissions"
    @qualities = Quality.new_list.paginate(:page => params[:page])
  end

end
