module PlacementsHelper

  def job_now
    if @user.no_current_job?(@business)
      return "No job assigned"
    else
      return "#{@user.current_job(@business).job_title} - #{@user.current_job(@business).department.name}"
    end 
  end
  
  def start_job_now
    if @user.no_current_job?(@business)
      return nil
    else
      return "(from #{display_date(@user.current_placement(@business).started_job)})"
    end 
  end
end
