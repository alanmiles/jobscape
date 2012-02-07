class PlansController < ApplicationController


  def show
    @plan = Plan.find(params[:id])
    @job = Job.find(@plan.job_id)
    @outline = Outline.find_by_job_id(@job.id)
    @business = Business.find(@job.business_id)
    @responsibilities = @plan.current_responsibilities
    @jobqualities = @plan.jobqualities.order("jobqualities.position")
    @requirements = @plan.requirements.order("requirements.position")
    if current_user.account == 3
      @title = "A-Plan"
    else
      @title = "Your A-Plan"
    end
  end
  
  def intro
    @plan = Plan.find(params[:id])
    @title = "A-Plan intro"
  end
  
  def uses
    @plan = Plan.find(params[:id])
    @title = "A-Plan uses"
  end
  
  def writing
    @plan = Plan.find(params[:id])
    @title = "Writing the A-Plan"
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
