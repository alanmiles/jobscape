class PlansController < ApplicationController


  def show
    @business = Business.find(session[:biz])
    @plan = Plan.find(params[:id])
    @job = Job.find(@plan.job_id)
    @outline = Outline.find_by_job_id(@job.id)
  end
  
  def update
    @plan = Plan.find(params[:id])
    if @plan.update_attributes(params[:plan])
      if @plan.no_changes?
        flash[:success] = "This A-Plan has now been locked.  Only a HYGWIT administrator (including you, of course) can edit 
                        the Plan or unlock it."
      else
        flash[:success] = "This A-Plan has now been unlocked.  Jobholders are now permitted to edit the Plan."
      end
      redirect_to @plan
    else
      flash[:error] = "Sorry, you appear not to have the authority to lock this A-Plan."
      @business = Business.find(session[:biz])
      @job = Job.find(@plan.job_id)
      @outline = Outline.find_by_job_id(@job.id) 
      render 'show'
    end
  end

end
