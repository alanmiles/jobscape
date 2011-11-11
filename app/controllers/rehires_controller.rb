class RehiresController < ApplicationController
  
  before_filter :authenticate
  before_filter :officer_user
  before_filter :started_business_session
  before_filter :correct_business
  
  def new
    @user = User.find(params[:user_id])
    @placement = @user.placements.build
    @business = Business.find(session[:biz])
    @jobs = @business.available_jobs
    @title = "Reactivate user"
  end
  
  def create
    @user = User.find(params[:user_id])
    @business = Business.find(session[:biz])
    @placement = @user.placements.new(params[:placement])
    if @placement.save
      @employee = Employee.find_by_business_id_and_user_id(@business, @user)
      @employee.update_attribute(:left, false)
      flash[:success] = "Successfully reactivated #{@user.name}."
      redirect_to officer_user_path(@user)
    else
      @title = "Reactivate user"
      @jobs = @business.available_jobs
      render 'new'
    end
  end

end
