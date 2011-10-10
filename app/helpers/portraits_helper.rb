module PortraitsHelper

  def legality
    if @portrait.right_to_work == true
      return "I have the legal right to work in this country."
    else
      return "I am not permitted to work in this country."
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
