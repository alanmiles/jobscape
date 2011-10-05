class UsersController < ApplicationController
  before_filter :authenticate, :only => [:index, :edit, :update, :show, :destroy]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => :destroy
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
    @accounts = User::ACCOUNT_TYPES
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
        if @user.account == 2
          redirect_to jobseeker_home_path
        elsif @user.account == 3
          redirect_to new_business_path
        else
          redirect_to @user
        end
      else
        @user.password = nil
        @user.password_confirmation = nil
        @title = "Sign up"
        @accounts = User::ACCOUNT_TYPES
        render 'new'
      end
    else
      flash[:error] = "You need to check the 'Accept terms' box before you can continue."
      @user.password = nil
      @user.password_confirmation = nil
      @title = "Sign up"
      @accounts = User::ACCOUNT_TYPES
      render 'new'
    end
  end
  
  def edit
    @title = "Edit account settings"
    @user = User.find(params[:id])
    @accounts = User::ACCOUNT_TYPES
  end
  
  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated. Check that the details are correct."
      redirect_to @user
    else
      @title = "Edit account settings"
      @accounts = User::ACCOUNT_TYPES
      render 'edit'
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    if @user == current_user
      flash[:notice] = "You're not allowed to delete your own record."
    else
      @user.destroy
      flash[:success] = "User destroyed."
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
