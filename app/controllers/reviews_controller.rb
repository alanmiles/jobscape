class ReviewsController < ApplicationController
  
  def new
    @user = current_user
    @job = Job.find(session[:jobid])
    @placement = Placement.find_by_user_id_and_job_id_and_current(@user, @job, true)
    @review = Review.new(:reviewee_id => @user.id, :reviewer_id => @user.id, 
      		:reviewer_name => @user.name, :job_id => @job.id, :placement_id => @placement.id)
    @title = "Set up a new performance review"  
  end
  
  def create
    @review = Review.new(params[:review])
    if @review.save
      if @review.review_type == 1
        flash[:success] = "New self-appraisal session started"
        redirect_to edit_self_appraisal_path(@review)
      else
        flash[:success] = "Now name your reviewer"
        redirect_to edit_reviewer_selection_path(@review)
      end
    else
      @user = current_user
      @job = Job.find(session[:jobid])
      @placement = Placement.find_by_user_id_and_job_id_and_current(@user, @job, true)
      #@review = Review.new(:reviewee_id => @user.id, :reviewer_id => @user.id, :reviewer_name => @user.name, :job_id => @job.id)
      @title = "Set up a new performance review"
      render 'new'
    end
  
  end

end
