class PagesController < ApplicationController
  before_filter :authenticate, :only => [:user_home, :admin_home, :select_business]
  before_filter :admin_user, :only => :admin_home
  before_filter :not_admin_user, :only => :select_business
  #before_filter :not_with_single_business, :only => :select_business
  
  def home
    session[:biz] = nil
    if signed_in?
      if current_user.admin?
        redirect_to admin_path
      elsif current_user.account == 2
        redirect_to jobseeker_home_path
      elsif current_user.account == 3
        redirect_to officer_home_path
      elsif current_user.account == 4
        redirect_to employee_home_path
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
    if @user.single_business?
      redirect_to officer_home_path
    else
      @employees = Employee.all_except_private(@user)
      session[:biz] = nil
    end
  end
  
  def biz_selection
    @business = Business.find(params[:id])
    session[:biz] = @business.id
    redirect_to officer_home_path 
  end
  
  def jobseeker_home
    @title = "Jobseeker Home"
    @user = current_user
    session[:jobid] = nil
  end
  
  def officer_home
    @title = "Officer Home"
    @user = current_user
    @no_business = false
    if session[:biz] != nil
      @business = Business.find(session[:biz])
      @employee = Employee.find_by_business_id_and_user_id(@business.id, @user.id)
      session[:jobid] = nil
    else
      if @user.belongs_to_business?
        if @user.single_business?
          @business = @user.businesses.first
          @employee = Employee.find_by_user_id(@user)
          session[:biz] = @business.id
        else
          redirect_to select_business_path
          session[:biz] = nil
        end
      else
        session[:biz] = nil
        @no_business = true
      end
    end
    #@business = Business.find(session[:biz])
    #@user = current_user
    #@employee = Employee.find_by_business_id_and_user_id(@business.id, @user.id)
    #session[:jobid] = nil
  end
  
  def user_home
    @title = "User Home"
    @user = current_user
    if @user.has_private_business?
      @business = @user.private_business
      session[:biz] = @business.id
    else
      flash[:notice] = "Sorry, something appears to be missing.  To solve the problem, make sure everything 
           on this page is correct, enter your password and password confirmation again, and hit the 'Confirm' button."
      redirect_to edit_user_path(@user)
    end
    
    #if @user.belongs_to_business?
    #  if @user.single_business?
    #    @business = @user.businesses.first
    #    @employee = Employee.find_by_user_id(@user)
    #    session[:biz] = @business.id
    #    if @employee.officer?
    #      redirect_to officer_home_path
    #    end
    #  else
    #    #@employees = Employee.find_all_by_user_id(@user)
    #    redirect_to select_business_path
    #  end
    #end
  end
  
  def employee_home
    @title = "Employee Home"
    @user = current_user
  end
  
  private
  
    #def not_with_single_business
    #  if current_user.single_business?
    #    redirect_to user_home_path, :message => "Not available if you belong to only one business"  
    #  end
    #end

end
