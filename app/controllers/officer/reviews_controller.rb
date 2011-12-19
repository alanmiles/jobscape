class Officer::ReviewsController < ApplicationController
  
  
  def index
    @business = Business.find(session[:biz])
    @reviews = @business.reviews_in_progress.paginate(:page => params[:page])
    @title = "Reviews in progress"
  end
 
  def show
    @review = Review.find(params[:id])
    @business = Business.find(session[:biz])
    @responsibilities = @review.reviewresponsibilities.order("rating_value DESC")
    @qualities = @review.reviewqualities.order("position")
    @title = "Review details"
  end
  
  def new
    @reviewee = User.find(session[:reviewee])
    @business = Business.find(session[:biz])
    @review = Review.new
    @review.reviewee_id = @reviewee.id
    @review.seen_by_reviewee = false
    @review.job_id = @reviewee.current_job(@business).id
    @review.placement_id = @reviewee.current_placement(@business).id
    if session[:reviewreq] == "self"
      @review.reviewer_id = @reviewee.id
    end
    @review.reviewer_name = @reviewee.name
    @departments = @business.current_departments
    @title = "Set up review" 
  end
  
  def create
    @review = Review.new(params[:review])
    @user = current_user
    if @review.save
      if @review.reviewer_id != @review.reviewee_id
        @review.update_attributes(:reviewer_name => @review.reviewer.name,
        			  :review_type => 2)
        ReviewMailer.review_notification(@review, @user).deliver
        if @user.id == @review.reviewer_id
          flash[:success] = "You've set a review in motion, and sent an email notification to #{@review.reviewee.name}."
        else
          ReviewMailer.reviewer_request(@review, @user).deliver
          flash[:success] = "You've set a review in motion, and the parties have been notified by email."
        end
      else
        ReviewMailer.appraisal_notification(@review, @user).deliver
        flash[:success] = "You've initiated a self-appraisal, and sent an email reminder to #{@review.reviewee.name}."			  
      end
      if session[:reviewreq] == "self"
        redirect_to no_appraisals_path
      else
        redirect_to no_reviews_path
      end
    else
      @reviewee = User.find(session[:reviewee])
      @business = Business.find(session[:biz])
      @review.reviewee_id = @reviewee.id
      @review.seen_by_reviewee = false
      @review.job_id = @reviewee.current_job(@business)
      @review.placement_id = @reviewee.current_placement(@business)
      @review.reviewer_name = @reviewee.name
      @departments = @business.current_departments
      @title = "Set up review" 
      render 'edit'
    end
  end
  
end
