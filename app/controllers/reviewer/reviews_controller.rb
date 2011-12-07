class Reviewer::ReviewsController < ApplicationController
  
  def index
    @user = current_user
    @business = Business.find(session[:biz])
    @reviews = @user.review_requests(@business)
    @title = "Performance review requests"
  end

  def edit
    @user = current_user
    @review = Review.find(params[:id])
    @qualities = @review.reviewqualities.order("reviewqualities.position")
    @job = Job.find(@review.job_id)
    @business = Business.find(@job.business_id)
    @department = Department.find(@job.department_id)
    @grades = Reviewquality::PAM_SCORES
    @title = "Performance review"
  end
  
end
