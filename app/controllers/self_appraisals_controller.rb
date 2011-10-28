class SelfAppraisalsController < ApplicationController
  
  
  def new
    @user = current_user
    @job = Job.find(session[:jobid]) 
    @review = Review.new(:reviewee_id => @user.id, :reviewer_id => @user.id, :reviewer_name => @user.name, :job_id => @job.id)
    @title = "New performance review"    
  end
  
  def create
    @review = Review.new(params[:review])
    if @review.save
      flash[:success] = "New review session started"
      redirect_to edit_self_appraisal_path(@review)
    else
      @user = current_user
      @job = Job.find(session[:jobid])
      #@review = Review.new(:reviewee_id => @user.id, :reviewer_id => @user.id, :reviewer_name => @user.name, :job_id => @job.id)
      @title = "New performance review"
      render 'new'
    end
  end
  
  def edit
    @review = Review.find(params[:id])
    if @review.self_appraisal?
      @title = "Self-appraisal for #{current_user.name}"
    else
      @title = "Review for #{current_user.name}"
    end
  end

end
