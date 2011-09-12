class PagesController < ApplicationController
  before_filter :authenticate, :only => [:user_home, :admin_home, :select_business]
  before_filter :admin_user, :only => :admin_home
  before_filter :not_admin_user, :only => :select_business
  before_filter :not_with_single_business, :only => :select_business
  
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
  
  def select_business
    @title = "Select business"
    @user = current_user
    @employees = Employee.find_all_by_user_id(@user)
    session[:biz] = nil
  end
  
  def officer_home
    @business = Business.find(session[:biz])
    @user = current_user
    @employee = Employee.find_by_business_id_and_user_id(@business.id, @user.id)
    session[:jobid] = nil
  end
  
  def user_home
    @title = "User Home"
    @user = current_user
    if @user.belongs_to_business?
      if @user.single_business?
        @business = @user.businesses.first
        @employee = Employee.find_by_user_id(@user)
        session[:biz] = @business.id
        if @employee.officer?
          redirect_to officer_home_path
        end
      else
        #@employees = Employee.find_all_by_user_id(@user)
        redirect_to select_business_path
      end
    end
  end
  
  private
  
    def not_with_single_business
      if current_user.single_business?
        redirect_to user_home_path, :message => "Not available if you belong to only one business"  
      end
    end

end
