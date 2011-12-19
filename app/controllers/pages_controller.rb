class PagesController < ApplicationController
  before_filter :authenticate, :only => [:user_home, :admin_home, :select_business]
  before_filter :admin_user, :only => :admin_home
  #before_filter :not_admin_user, :only => :select_business
  #before_filter :not_with_single_business, :only => :select_business
  
  def home
    session[:biz] = nil
    if signed_in?
      if current_user.account == 2
        @path = jobseeker_home_path
      elsif current_user.account == 3
        @path = officer_home_path  
      elsif current_user.account == 4
        @path = employee_home_path
      else  
        @path = user_home_path
      end
      
      if current_user.admin?
        if session[:admin_off] == nil
          redirect_to admin_path
        else
          redirect_to @path
        end
      else 
        redirect_to @path
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
    @user = User.find(current_user)
    session[:admin_off] = nil
  end
  
  def select_business
    @title = "Select business"
    @user = current_user
    if @user.single_business?
      if @user.account == 3
        redirect_to officer_home_path
      elsif @user.account == 4
        redirect_to employee_home_path
      end
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
  
  def admin_to_standard
    session[:admin_off] = true
    redirect_to root_path
  end
  
  def standard_to_admin
    session[:admin_off] = nil
    redirect_to root_path
  end
  
  def officer_to_own
    session[:officer_off] = true
    redirect_to employee_home_path
  end
  
  def own_to_officer
    session[:officer_off] = nil
    redirect_to officer_home_path
  end
  
  def employee_selection
    @business = Business.find(params[:id])
    session[:biz] = @business.id
    redirect_to employee_home_path
  end
  
  def jobseeker_home
    @title = "Jobseeker Home"
    @user = current_user
    session[:jobid] = nil
    clear_return_to
  end
  
  def jobsearch_menu
    clear_return_to
    @title = "Job-Search menu"
    @user = current_user
  end
  
  def officer_home
    @title = "Officer Home"
    @user = current_user
    @no_business = false
    session[:dept_id] = nil
    session[:reviewreq] = nil 
    session[:reviewee] = nil
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
  end
  
  def user_home
    @title = "User Home"
    @user = current_user
    clear_return_to
    if @user.has_private_business?
      @business = @user.private_business
      session[:biz] = @business.id
    else
      flash[:notice] = "Sorry, something appears to be missing.  To solve the problem, make sure everything 
           on this page is correct, enter your password and password confirmation again, and hit the 'Confirm' button."
      redirect_to edit_user_path(@user)
    end
  end
    
  def my_job
    @title = "Your Job"
    @user = current_user
    @business = Business.find(session[:biz])
    @business.remove_disconnected_jobs
    
    if @user.has_completed_reviews?(@business)
      @last_review = @user.last_review(@business)
    end
    
    if @user.no_job?
      flash[:notice] = "You haven't entered your job-title yet, so let's get started with that ..."
      redirect_to new_business_job_path(@business)
    else
      @placement = Placement.where("user_id = ? and current = ?", @user.id, true).first
      @job = Job.where("id = ?", @placement.job_id).first
      session[:jobid] = @job.id
      @plan = Plan.find_by_job_id(@job)
      if @user.has_incomplete_review?(@business)
        @review = @user.incomplete_review(@business).first
      end
    end
  end
  
  def employee_home
    session[:invited] = nil
    session[:dept_id] = nil
    @title = "Employee Home"
    @user = current_user
    
    @no_business = false
    if session[:biz] != nil
      @business = Business.find(session[:biz])
      @employee = Employee.find_by_business_id_and_user_id(@business.id, @user.id)
      @job = @user.current_job(@business)
      @plan = Plan.find_by_job_id(@job)
      session[:jobid] = @job.id
    else
      if @user.belongs_to_business?
        if @user.single_business?
          @business = @user.sole_business
          @employee = Employee.find_by_user_id_and_business_id(@user, @business)
          @job = @user.current_job(@business)
          @plan = Plan.find_by_job_id(@job)
          session[:biz] = @business.id
          session[:jobid] = @job.id
        else
          redirect_to select_business_path
          session[:biz] = nil
        end
      else
        session[:biz] = nil
        @no_business = true
      end
    end
    
    unless session[:biz] == nil
      if @user.has_incomplete_review?(@business)
        @review = Review.find(@user.incomplete_review(@business))
      end
      if @user.has_review_requests?(@business)
        if @user.review_requests(@business).count == 1
          @review_requested = @user.review_requests(@business).first
        end
      end
    end
    #@employee = Employee.where("user_id =?", @user).first
    #@business = Business.find(@employee.business_id)
    #session[:biz] = @business.id
  end
  
  def locked_aplan
    @user = current_user
    @business = Business.find(session[:biz])
    @job_title = @user.current_job(@business).job_title
    @officers = @business.officer_list
    @title = "Locked A-Plan"
  end
  
  def hygwit_introduction
    @title = "Introduction to HYGWIT"
  end
  
  def performance_reviews
    @user = current_user
    @business = Business.find(session[:biz])
    @title = "Performance reviews"
    session[:reviewreq] = nil
    session[:reviewee] = nil
  end
  
  private
  
    #def not_with_single_business
    #  if current_user.single_business?
    #    redirect_to user_home_path, :message => "Not available if you belong to only one business"  
    #  end
    #end

end
