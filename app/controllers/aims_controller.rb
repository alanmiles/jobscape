class AimsController < ApplicationController
  
  def index
    @user = current_user
    @aims = @user.aims.order("aims.position")
    @title = "Aims"
  end

  def sort
    @user = current_user
    @user.aims.each do |f|
      f.position = params["aim"].index(f.id.to_s)+1
      f.save
    end
    render :nothing => true  
  end  
  
  def new
    @user = current_user
    @aim = @user.aims.new
    @title = "Add an aim"
  end
  
  def create
    @user = current_user
    @aim = @user.aims.new(params[:aim])
    if @aim.save
      if @user.max_aims?
        flash[:success] = "Aim successfully added - you've now entered all 3 aims allowed."
      else
        flash[:success] = "Aim successfully added."
      end
      redirect_to user_aims_path(@user)
    else
      @title = "Add an aim"
      render 'new'
    end
  end

  def edit
    @user = current_user
    @aim = Aim.find(params[:id])
    @title = "Edit aim"
  end
  
  def update
    @aim = Aim.find(params[:id])
    if @aim.update_attributes(params[:aim])
      flash[:success] = "Aim updated."
      redirect_to user_aims_path(@aim.user_id)
    else
      @title = "Edit aim"
      render 'edit'
    end
  end
  
  def destroy
    @aim = Aim.find(params[:id])
    @aim.destroy
    flash[:success] = "Aim removed."
    redirect_to user_aims_path(@aim.user_id)
  end


end
