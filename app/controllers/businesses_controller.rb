class BusinessesController < ApplicationController
  
  before_filter :authenticate
  before_filter :admin_user, :only => [:index, :destroy]
  
  def index
    @title = "Businesses"
    @businesses = Business.signed_up.order("name").paginate(:page => params[:page])
    @nmbr = @businesses.count
  end

  def show
    @title = "Business"
    @business = Business.find(params[:id])
  end
  
  def new
    @title = "New business"
    @business = Business.new
    @sectors = Sector.order("sector")
  end

  def create
    @business = Business.new(params[:business])
    if @business.save
      if @business.latitude.nil?
        flash[:notice] = "The business has been added, BUT the address has not
         	          been recognized.  Please try again: if you used the
         	          post-code last time, try the postal address this time,
         	          or vice versa. (Max 50 characters)."
        @title = "Edit business"
        session[:biz] = @business.id
        @sectors = Sector.order("sector")
        redirect_to edit_business_path(@business)  
      else
        flash[:success] = "#{@business.name} added."
        session[:biz] = @business.id
        redirect_to @business
      end
      Employee.create!(:user_id => current_user.id, :business_id => @business.id,
                       :officer => true, :ref_no => 1)
      
    else
      @title = "New business"
      @sectors = Sector.order("sector")
      render 'new'
    end
  end
  
  def edit
    @title = "Edit business"
    @business = Business.find(params[:id])
    @sectors = Sector.order("sector")
  end
  
  def update
    @business = Business.find(params[:id])
    if @business.update_attributes(params[:business])
      flash[:success] = "Business details updated."
      redirect_to @business
    else
      @title = "Edit business"
      @sectors = Sector.order("sector")
      render 'edit'
    end
  end
  
  def destroy
    @business = Business.find(params[:id]).destroy
    flash[:success] = "'#{@business.name} - #{@business.city}' removed."
    redirect_to :back
  end
end
