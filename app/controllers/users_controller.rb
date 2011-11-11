class UsersController < ApplicationController
  before_filter :authenticate, :only => [:index, :edit, :update, :show, :destroy]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => [:index, :destroy]
  before_filter :signedin,     :only => [:new, :create]
  
   def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])
  end
  
  def show
    @user = User.find(params[:id])
    @title = @user.name
  end
  
  def new
    @user = User.new
    @title = "Sign up"
    if session[:invited] == nil
      @accounts = User::ACCOUNT_TYPES
    else
      @invitation = Invitation.find(session[:invited])
      @user.account = 4
      @user.name = @invitation.name
      @user.email = @invitation.email
      @business = Business.find(@invitation.business_id)
      session[:biz] = @business.id
    end
  end

  def create
    @user = User.new(params[:user])
    @ip_address = request.remote_ip
    if @ip_address == "127.0.0.1" || @ip_address == nil
      @user.address = "82.44.3.178"
    else
      @user.address = @ip_address
    end
    if @user.terms?
      if @user.save
        sign_in @user
        flash[:success] = "Welcome to HYGWIT - Have You Got What It Takes?"
        if @user.account == 1
          redirect_to user_home_path
        elsif @user.account == 2
          redirect_to jobseeker_home_path
        elsif @user.account == 3
          redirect_to new_business_path
        elsif @user.account == 4
          @business = Business.find(session[:biz])
          @invitation = Invitation.find(session[:invited])
          if @invitation.staff_no == nil
            @top_ref = @business.next_ref_no
          else
            @top_ref = @invitation.staff_no
          end
          
          @employee = Employee.new(:business_id => @business.id,
          		:user_id => @user.id,
          		:ref_no => @top_ref)
          @employee.save
          
          @placement = Placement.new(:user_id => @user.id,
          		:job_id => @invitation.job_id,
          		:started_job => Date.today)
          @placement.save
          
          @invitation.update_attribute(:signed_up, true)  
          redirect_to employee_home_path
        end
      else
        @user.password = nil
        @user.password_confirmation = nil
        @title = "Sign up"
        if session[:invited] == nil
          @accounts = User::ACCOUNT_TYPES
        else
          @invitation = Invitation.find(session[:invited])
          @user.account = 4
          @user.name = @invitation.name
          @user.email = @invitation.email
          @business = Business.find(@invitation.business_id)
          session[:biz] = @business.id
        end
        render 'new'
      end
    else
      flash[:error] = "You need to check the 'Accept terms' box before you can continue."
      @user.password = nil
      @user.password_confirmation = nil
      @title = "Sign up"
      if session[:invited] == nil
        @accounts = User::ACCOUNT_TYPES
      else
        @invitation = Invitation.find(session[:invited])
        @user.account = 4
        @user.name = @invitation.name
        @user.email = @invitation.email
        @business = Business.find(@invitation.business_id)
        session[:biz] = @business.id
      end
      render 'new'
    end
  end
  
  def edit
    @title = "Edit account settings"
    @user = User.find(params[:id])
    if @user.account == 4
      @business = Business.find(session[:biz])
    else
      @accounts = User::ACCOUNT_TYPES
    end
  end
  
  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated. Check that the details are correct."
      session[:biz] = nil
      redirect_to @user
    else
      @title = "Edit account settings"
      if @user.account == 4
        @business = Business.find(session[:biz])
      else
        @accounts = User::ACCOUNT_TYPES
      end
      render 'edit'
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    if @user == current_user
      flash[:notice] = "You're not allowed to delete your own record."
    else
      @user.destroy
      flash[:success] = "#{@user.name} deleted."
    end
    redirect_to users_path
  end
  
  private
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
    
    def signedin
      if signed_in?
        flash[:notice] = "You're already signed up"
        redirect_to(user_path(current_user))
      end 
    end
end
