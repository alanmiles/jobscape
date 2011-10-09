class LimitationsController < ApplicationController
  
  
  def index
    @user = current_user
    @limitations = @user.limitations.order("limitations.position")
    @title = "My limitations"
  end

  def sort
    @user = current_user
    @user.limitations.each do |f|
      f.position = params["limitation"].index(f.id.to_s)+1
      f.save
    end
    render :nothing => true  
  end  
  
  def new
    @user = current_user
    @limitation = @user.limitations.new
    @title = "Limitations"
  end
  
  def create
    @user = current_user
    @limitation = @user.limitations.new(params[:limitation])
    if @limitation.save
      if @user.max_limitations?
        flash[:success] = "Limitation successfully added - you've now entered all 3 limitations allowed."
      else
        flash[:success] = "Limitation successfully added."
      end
      redirect_to user_limitations_path(@user)
    else
      @title = "Limitations"
      render 'new'
    end
  end

  def edit
    @user = current_user
    @limitation = Limitation.find(params[:id])
    @title = "Edit limitation"
  end
  
  def update
    @limitation = Limitation.find(params[:id])
    if @limitation.update_attributes(params[:limitation])
      flash[:success] = "Limitation updated."
      redirect_to user_limitations_path(@limitation.user_id)
    else
      @title = "Edit limitation"
      render 'edit'
    end
  end
  
  def destroy
    @limitation = Limitation.find(params[:id])
    @limitation.destroy
    flash[:success] = "Limitation removed."
    redirect_to user_limitations_path(@limitation.user_id)
  end

end
