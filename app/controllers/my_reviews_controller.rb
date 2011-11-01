class MyReviewsController < ApplicationController
  
  def index
    @user = current_user
    @job = Job.find(session[:jobid])
    @reviews = Review.completed_for(@user).paginate(:page => params[:page])
    @title = "Your review history"
  end

  def show
    @review = Review.find(params[:id])
    if @review.self_appraisal?
      @title = "Self-appraisal"
    else
      @title = "Your performance reviewed"
    end
    @responsibilities = @review.reviewresponsibilities.order("rating_value DESC")
    @qualities = @review.reviewqualities.order("position")
  end

end
