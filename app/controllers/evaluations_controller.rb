class EvaluationsController < ApplicationController
  
  before_filter :authenticate
  #before_filter :not_admin_user
  before_filter :correct_job
  
  def edit
    @job = Job.find(session[:jobid])
    @plan = Plan.find_by_job_id(@job.id)
    @evaluation = Evaluation.find(params[:id])
    @responsibility = Responsibility.find(@evaluation.responsibility_id)
    @title = "Responsibility rating"
    @ratings = Evaluation::RATING_TYPES
  end
  
  def update
    @evaluation = Evaluation.find(params[:id])
    @responsibility = Responsibility.find(@evaluation.responsibility.id)
    if @evaluation.update_attributes(params[:evaluation])
      flash[:success] = "Rating recalculated."
      redirect_to session[:return_to]
    else
      @title = "Responsibility rating"
      @job = Job.find(session[:jobid])
      @plan = Plan.find_by_job_id(@job.id)
      @ratings = Evaluation::RATING_TYPES
      render 'edit'
    end 
  
  end

end
