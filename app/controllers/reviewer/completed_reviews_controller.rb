class Reviewer::CompletedReviewsController < ApplicationController
  
  def index
    @user = current_user
    @reviews = @user.recent_reviewer_sessions.paginate(:per_page => 20, :page => params[:page])
    @business = Business.find(session[:biz])
    @title = "Completed reviews"
  end

end
