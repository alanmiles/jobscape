class ReviewerSelectionsController < ApplicationController
  
  def edit
    @user = current_user
    @review = Review.find(params[:id])
    @business = Business.find(session[:biz])
    @department = Department.find(@user.current_department(@business))
    @title = "Identify your reviewer"
    
  end
  
  def update
  
  end

end
