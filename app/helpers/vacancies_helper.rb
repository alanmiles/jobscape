module VacanciesHelper

  def vacant_position
    if @vacancy.quantity == 1
      @vacancy.job.job_title
    else
      "#{@vacancy.quantity} #{@vacancy.job.job_title.pluralize}" 
    end
  end
  
end
