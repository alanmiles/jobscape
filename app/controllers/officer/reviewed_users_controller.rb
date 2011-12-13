class Officer::ReviewedUsersController < ApplicationController
  
  def index
    @business = Business.find(session[:biz])
    @users = @business.all_current_employees.paginate(:page => params[:page])
    @title = "Latest performance reviews"
  end

  def show
    @user = User.find(params[:id])
    @business = Business.find(session[:biz])
    @reviews = Review.completed_for(@user, @business).paginate(:page => params[:page])
    @title = "Review History"
  end

end
