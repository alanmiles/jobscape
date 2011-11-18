class OccupationsController < ApplicationController
  
  before_filter :authenticate
  before_filter :admin_user
  
  def index
    @title = "Occupations"
    @occupations = Occupation.order("name").paginate(:page => params[:page])
  end
  
  def new
    @title = "New occupation"
    @occupation = Occupation.new
  end

  def create
    @occupation = Occupation.new(params[:occupation])
    if @occupation.save
      flash[:success] = "#{@occupation.name} added."
      redirect_to occupations_path
    else
      @title = "New occupation"
      render 'new'
    end
  end
  
  def edit
    @title = "Edit occupation"
    @occupation = Occupation.find(params[:id])
  end
  
  def update
    @occupation = Occupation.find(params[:id])
    if @occupation.update_attributes(params[:occupation])
      flash[:success] = "#{@occupation.name} updated."
      redirect_to occupations_path
    else
      @title = "Edit occupation"
      render 'edit'
    end
  end
  
  def destroy
    @occupation = Occupation.find(params[:id])
    if @occupation.associated_jobs?
      flash[:error] = " Cannot delete occupation while associated jobs exist"
    else
      @occupation.destroy
      flash[:success] = "#{@occupation.name} removed."
    end
    #redirect_to occupations_path
    redirect_to :back
  end

end
