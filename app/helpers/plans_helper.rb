module PlansHelper

  def outline_status
    if @outline.complete?
      return "Completed"
    else
      return "Incomplete"
    end
  end
  
  def job_valuation
    if @plan.job_value.nil? || @plan.job_value == 0
      return "n/a"      
    else
      @plan.job_value
    end
  end
end
