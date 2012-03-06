module PortraitsHelper

  def legality
    if @portrait.right_to_work == true
      return "Permitted to work in #{@user.country}."
    else
      return "Not permitted to work in #{@user.country}."
    end
  end
  
  def public_view
    if @portrait.public == true
      return "I've put my Portrait on public view."
    else
      return "MY PORTRAIT IS NOT PUBLIC."
    end 
  end
end
