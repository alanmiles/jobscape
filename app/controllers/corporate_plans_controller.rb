class CorporatePlansController < ApplicationController
  
  def show
    @business = Business.find(params[:id])
    @objectives = @business.objectives.order("objectives.focus, objectives.objective")
    @title = "Business Strategy"
  end

  def edit
    @business = Business.find(params[:id])
    @title = "Edit strategy"
    @characters_mission = 500 - @business.mission.length
    @characters_values = 500 - @business.values.length
  end
  
  def update
    @business = Business.find(params[:id])
    if @business.update_attributes(params[:business])
      flash[:success] = "You've successfully updated the business plan"
      redirect_to corporate_plan_path(@business)
    else
      @title = "Edit strategy"
      render 'edit'
    end
  end

end
