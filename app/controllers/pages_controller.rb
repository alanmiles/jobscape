class PagesController < ApplicationController
  before_filter :authenticate, :only => [:user_home, :admin_home]
  before_filter :admin_user, :only => :admin_home
  
  def home
    if signed_in?
      if current_user.admin?
        redirect_to admin_path
      else
        redirect_to user_menu_path
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
  
  def user_home
    @title = "User Menu"
    @user = current_user
  end  
end
