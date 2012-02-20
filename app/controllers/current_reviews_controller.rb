class CurrentReviewsController < ApplicationController
  
  def index
  end

  
  def edit
    @review = Review.find(params[:id])
    @user = current_user
    @business = Business.find(session[:biz])
    @department = Department.find(@user.current_department(@business))
    if @review.review_type == 2
      @users = User.all_active_in(@department)
    elsif @review.review_type == 3
      @users = @business.all_current_employees
    end
    @title = "Colleague review plan"
  end
  
  def update
    @review = Review.find(params[:id])
    if @review.update_attributes(params[:review])
      if @review.cancel == true
        flash[:notice] = "The planned review by #{@review.reviewer.name} has now been cancelled."
      else
        if @review.consent == false
          flash[:notice] = "You didn't confirm that you've seen the previous form, so the review has not yet
                      been cancelled.  This prevents you from setting up a new review."
        else
          flash[:success] = "Any changes you made to your current review have been recorded.
                         The reviewer is #{@review.reviewer.name}."
        end
      end
      redirect_to employee_home_path
    else
      @user = current_user
      @business = Business.find(session[:biz])
      @department = Department.find(@user.current_department(@business))
      if @review.review_type == 2
        @users = User.all_active_in(@department)
      elsif @review.review_type == 3
        @users = @business.all_current_employees
      end
      @title = "Your current review plans"
      render 'edit'
    end
  end

end
