module LatestVacanciesHelper

  def vacant_position
    if vacancy.quantity == 1
      vacancy.job.job_title
    else
      "#{vacancy.quantity} #{vacancy.job.job_title.pluralize}" 
    end
  end
  
  def your_application_status
    @application = @vac.application_from(current_user)
    if @application.next_action == 0
      return "You decided that this job was not suitable."
    elsif @application.next_action == 1
      return "You've bookmarked this job."
    else
      if @application.submitted == false
        return "You're planning to apply for this job, but still need to complete your application."
      else
        @s_date = time_ago_in_words(@application.submission_date)
        return "You applied for this job #{@s_date} ago."
      end
    end
  end
  
end
