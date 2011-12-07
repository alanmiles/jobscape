class ReviewerSelectionsController < ApplicationController
  
  def edit
    @user = current_user
    @review = Review.find(params[:id])
    @business = Business.find(session[:biz])
    @department = Department.find(@user.current_department(@business))
    if @review.review_type == 2
      @users = User.all_active_in(@department)
    elsif @review.review_type == 3
      @users = @business.all_current_employees
    end
    @title = "Identify your reviewer"
    
  end
  
  def update
    @review = Review.find(params[:id])
    if @review.update_attributes(params[:review])
      flash[:success] = "You've selected #{@review.reviewer.name} as your reviewer."
      redirect_to employee_home_path
    else
      @user = current_user
      @business = Business.find(session[:biz])
      @department = Department.find(@user.current_department(@business))
      @users = User.all_active_in(@department)
      @title = "Identify your reviewer"
      render 'edit'
    end
  end

end
