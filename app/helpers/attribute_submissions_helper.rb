module AttributeSubmissionsHelper

  def header
    if @quality.rejected?
      "Attribute rejected"
    else
      "Attribute submitted"
    end
  end
  
  def choose_route
    if @quality.rejected?
      link_to "All rejections", attribute_rejections_path
    else
      link_to "All submissions", attribute_submissions_path
    end
  end
  
  def cancel_route
    if @quality.rejected?
      link_to "Cancel", attribute_rejections_path
    else
      link_to "Cancel", attribute_submissions_path
    end
  end
  
  def approval_header
    if @quality.rejected?
      "Approve rejected attribute?"
    else
      "Approve attribute submission?"
    end
  end
  
  def approval_instruction
    if @quality.rejected?
      "Uncheck 'Rejected' and check 'Approved' if you've changed your mind:-"
    else
      "Check ONE of the two boxes below:-"
    end
  end
end





