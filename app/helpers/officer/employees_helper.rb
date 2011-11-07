module Officer::EmployeesHelper

  def leaver_message
    if @employee.left?
      return "Clear the checkbox if this person is now rejoining the business."
    else
      if @employee.user_id == current_user.id
        if @employee.business.needs_an_officer?
          return "Your leaving details can only be entered by someone else - so if you're planning to leave, 
                you need to appoint another HYGWIT officer first."
        else
          return "Only another HYGWIT officer can enter your leaver status."
        end
      else
        return "Check the box if this person has left the business."
      end
    end
  end
  
  def hygwit_officer
    if @employee.user_id == current_user.id
      return "Only another officer can change your HYGWIT access rights."
    elsif @employee.officer?
      return "Clear the checkbox if you no longer want this person to have access to all HYGWIT records.  
             (There must be at least one officer.)"
    else
      return "Check the box if you want to give this person access to all HYGWIT records,
              just like yourself.  (You should have at least two officers.)"
    end
  end
  
  def officer_status
    if @employee.officer?
      return "YES"
    else
      return "NO"
    end
  end
  
  def leaver_status
    if @employee.left?
      return "YES"
    else
      return "NO"
    end
  end
  
  
end
