class QualitiesController < ApplicationController
  
  before_filter :authenticate, :except => :index
  
  def index
    @title = "Personal Attributes"
    @qualities = Quality.official_list.paginate(:page => params[:page])
    @submissions = Quality.new_submissions
  end

  def new
    @title = "New Personal Attribute"
    @quality = Quality.new
    @quality.created_by = current_user.id
  end
  
  def create
    @quality = Quality.new(params[:quality])
    if @quality.save
      if current_user.admin?
        @quality.update_attributes(:approved => true,
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
    @title = "Attribute: #{@quality.quality}"
  end
  
  def edit
    @quality = Quality.find(params[:id])
    @title = "Edit attribute"
  end
  
  def update
    @quality = Quality.find(params[:id])
    @new_title = params[:quality][:quality]
    if @quality.update_attributes(params[:quality])
      @quality.update_attribute(:updated_by, current_user.id)
      flash[:success] = "'#{@new_title}' updated."
      redirect_to qualities_path
    else
      @title = "Edit attribute"
      render 'edit'
    end
  end

end
