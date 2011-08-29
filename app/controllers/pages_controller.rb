class PagesController < ApplicationController
  before_filter :authenticate, :only => [:user_home, :admin_home]
  before_filter :admin_user, :only => :admin_home
  
  def home
    if signed_in?
      if current_user.admin?
        redirect_to admin_path
      else
        redirect_to user_home_path
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
    @title = "User Home"
    @user = current_user
    if @user.belongs_to_business?
      if @user.single_business?
        @business = @user.businesses.first
        @employee = Employee.find_by_user_id(@user)
      else
        @employees = Employee.find_all_by_user_id(@user)
      end
    end
  end  
end
