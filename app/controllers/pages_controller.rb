class PagesController < ApplicationController
  def home
    if signed_in?
      if current_user.admin?
        redirect_to admin_path
      end
    else
      @title = "Home"
    end
  end

  def about
    @title = "About"
  end
  
  def help
    @title = "Help"
  end

  def contact
    @title = "Contact"
  end
  
  def admin_home
    @title = "Admin"
  end
    
end
