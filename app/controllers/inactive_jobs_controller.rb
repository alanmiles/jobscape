class InactiveJobsController < ApplicationController
  
  def index
    @business = Business.find(params[:business_id])
    @jobs = @business.inactive_jobs 
    @title = "Archived jobs"
  end

  def edit
    @job = Job.find(params[:id])
    @business = Business.find(@job.business_id)
    @title = "Reactivate job"
  end

  def update
   @job =Job.find(params[:id])
    if @job.update_attributes(params[:job])
      if @job.inactive == false
        flash[:success] = "'#{@job.title_department}' successfully reactivated."
        redirect_to business_jobs_path(@job.business_id)
      else
        flash[:notice] = "Your changes were dropped, because you left '#{@job.title_department}' inactive."
        redirect_to business_inactive_jobs_path(@job.business_id)
      end
    else
      @title = "Reactivate job"
      @business = Business.find(@job.business_id)
      render 'edit'
    end 
  end
  
  def destroy
    @department = Department.find(params[:id])
    @business = Business.find(session[:biz])
    
    if @department.has_inactive_jobs?
      flash[:success] = "#{@department.name} still has related archived jobs, so it can't be deleted" 
    else
      @department.destroy
      flash[:success] = "#{@department.name} has been completely removed."
    end
  
    redirect_to business_hidden_departments_path(@business)
  end

end
