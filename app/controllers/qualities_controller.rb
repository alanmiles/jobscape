class QualitiesController < ApplicationController
  
  before_filter :authenticate, :except => :index
  before_filter :no_business, :only => [:new, :create]
  
  def index
    @title = "Personal Attributes"
  end

  def new
    @title = "New Personal Attribute"
    @quality = Quality.new
    @quality.created_by = current_user.id
    @quality.business_id = session[:biz] unless session[:biz] == nil?
  end
  
  def create
    @quality = Quality.new(params[:quality])
    if @quality.save
      if current_user.admin?
        @quality.update_attributes(:business_id => nil,
                 :approved => true,
                 :seen => true)
      end
      flash[:success] = "#{@quality.quality} added. Now set the 5 PAMs."
      redirect_to @quality
    else
      @title = "New Personal Attribute"
      render 'new'
    end
  end
  
  def show
    @quality = Quality.find(params[:id])
    @title = "Personal Attribute"
  end
  
  private
  
    def no_business
      if signed_in?
        unless current_user.admin?
          if session[:biz] == nil
            flash[:notice] = "Illegal procedure. You must select a business 
              and use the buttons provided before you can create a new
              attribute."
            redirect_to select_business_path        
          end
        end
      end
    end

end
