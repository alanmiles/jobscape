class ObjectivesController < ApplicationController
  
  def index
  end

  def new
    @business = Business.find(params[:business_id])
    @objective = @business.objectives.build
    @characters_objective = 255
    @characters_measurement = 255
    @select_focus = true
    @title = "Add a company objective"
  end
  
  def create
    @business = Business.find(params[:business_id])
    @objective = @business.objectives.new(params[:objective])
    @focus = @objective.focus
    if @business.max_objectives_by_focus?(@focus)
      flash[:error] = "Sorry, you already have five objectives - the maximum - for #{@objective.focus_name.upcase}, so your
                   new objective cannot be accepted."
      redirect_to corporate_plan_path(@business)
    else
      if @objective.save
        flash[:success] = "The #{@objective.focus_name.upcase} objective was successfully added."
        redirect_to corporate_plan_path(@business) 
      else
        @characters_objective = 255 - @objective.objective.length
        @characters_measurement = 255 - @objective.measurement.length
        @select_focus = true
        @title = "Add a company objective"
        render 'new'
      end
    end
  end
  
  def edit
    @objective = Objective.find(params[:id])
    @business = Business.find(@objective.business_id)
    @characters_objective = 255 - @objective.objective.length
    @characters_measurement = 255 - @objective.measurement.length
    @select_focus = false
    @title = "Edit objective"
  end
  
  def update
    @objective = Objective.find(params[:id])
    @business = Business.find(@objective.business_id)
    if @objective.update_attributes(params[:objective])
      flash[:success] = "The #{@objective.focus_name.upcase} objective was successfully updated."
      redirect_to corporate_plan_path(@business) 
    else
      @title = "Edit objective"
      @characters_objective = 255 - @objective.objective.length
      @characters_measurement = 255 - @objective.measurement.length
      @select_focus = false
      render 'edit'
    end
  end

  def destroy
    @objective = Objective.find(params[:id]).destroy
    flash[:success] = "The #{@objective.focus_name.upcase} objective has been deleted."
    redirect_to corporate_plan_path(@objective.business_id) 
  
  end

end
