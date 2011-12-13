class MyReviewsController < ApplicationController
  
  def index
    @user = current_user
    @business = Business.find(session[:biz])
    @job = Job.find(session[:jobid])
    @reviews = Review.completed_for(@user, @business).paginate(:page => params[:page])
    @title = "Your review history"
  end

  def show
    @review = Review.find(params[:id])
    @job = Job.find(session[:jobid])
    @business = Business.find(session[:biz])
    if @review.self_appraisal?
      @title = "Self-appraisal"
    else
      @title = "Your performance reviewed"
    end
    @responsibilities = @review.reviewresponsibilities.order("rating_value DESC")
    @qualities = @review.reviewqualities.order("position")
  end

end
