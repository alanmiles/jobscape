module JobsHelper

  def plan_status
    if @plan.complete?
      "Complete - view/edit?"
    elsif @plan.has_responsibilities?
      "Incomplete - continue building"
    else
      "Create one now"
    end
  end
  
end
