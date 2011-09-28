class SectorsController < ApplicationController
  
  before_filter :authenticate
  before_filter :admin_user
  
  def index
    @title = "Sectors"
    @sectors = Sector.order("sectors.sector")
  end

  def new
    @title = "Add a sector"
    @sector = Sector.new
  end
  
  def create
    @sector = Sector.new(params[:sector])
    if @sector.save
      flash[:success] = "#{@sector.sector} added."
      redirect_to sectors_path
    else
      @title = "Add a sector"
      render 'new'
    end
  end

  def edit
    @sector = Sector.find(params[:id])
    @title = "Edit sector"
  end

  def update
    @sector = Sector.find(params[:id])
    if @sector.update_attributes(params[:sector])
      flash[:success] = "#{@sector.sector} updated."
      redirect_to sectors_path
    else
      @title = "Edit sector"
      render 'edit'
    end 
  end
  
  def destroy
    @sector = Sector.find(params[:id])
    if @sector.associated_businesses?
      flash[:error] = " Cannot delete sector while associated businesses exist"
    elsif @sector.associated_vacancies?
      flash[:error] = " Cannot delete sector while associated vacancies exist"
    else
      @sector.destroy
      flash[:success] = "#{@sector.sector} removed."
    end
    redirect_to sectors_path
  end
end
