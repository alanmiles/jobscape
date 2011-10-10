class CharacteristicsController < ApplicationController
  
  def index
    @user = current_user
    @characteristics = @user.characteristics.order("characteristics.position")
    @title = "Characteristics"
  end

  def sort
    @user = current_user
    @user.characteristics.each do |f|
      f.position = params["character"].index(f.id.to_s)+1
      f.save
    end
    render :nothing => true  
  end  
  
  def new
    @user = current_user
    @characteristic = @user.characteristics.new
    @title = "Add a characteristic"
  end
  
  def create
    @user = current_user
    @characteristic = @user.characteristics.new(params[:characteristic])
    if @characteristic.save
      if @user.max_characteristics?
        flash[:success] = "Characteristic successfully added - you've now entered all 5 characteristics allowed."
      else
        flash[:success] = "Characteristic successfully added."
      end
      redirect_to user_characteristics_path(@user)
    else
      @title = "Add a characteristic"
      render 'new'
    end
  end

  def edit
    @user = current_user
    @characteristic = Characteristic.find(params[:id])
    @title = "Edit characteristic"
  end
  
  def update
    @characteristic = Characteristic.find(params[:id])
    if @characteristic.update_attributes(params[:characteristic])
      flash[:success] = "Characteristic updated."
      redirect_to user_characteristics_path(@characteristic.user_id)
    else
      @title = "Edit characteristic"
      render 'edit'
    end
  end
  
  def destroy
    @characteristic = Characteristic.find(params[:id])
    @characteristic.destroy
    flash[:success] = "Characteristic removed."
    redirect_to user_characteristics_path(@characteristic.user_id)
  end

end