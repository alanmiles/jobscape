module PlansHelper

  def outline_status
    if @outline.complete?
      return "Completed"
    else
      return "Incomplete"
    end
  end
end
