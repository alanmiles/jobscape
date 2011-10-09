class StrengthsController < ApplicationController
  
  def index
    @user = current_user
    @strengths = @user.strengths.order("strengths.position")
    @title = "My strengths"
  end

  def sort
    @user = current_user
    @user.strengths.each do |f|
      f.position = params["strength"].index(f.id.to_s)+1
      f.save
    end
    render :nothing => true  
  end  
  
  def new
    @user = current_user
    @strength = @user.strengths.new
    @title = "Add one of your strengths"
  end
  
  def create
    @user = current_user
    @strength = @user.strengths.new(params[:strength])
    if @strength.save
      if @user.max_strengths?
        flash[:success] = "Strength successfully added - you've now entered all 5 special strengths allowed."
      else
        flash[:success] = "Strength successfully added."
      end
      redirect_to user_strengths_path(@user)
    else
      @title = "Add one of your strengths"
      render 'new'
    end
  end

  def edit
    @user = current_user
    @strength = Strength.find(params[:id])
    @title = "Edit strength"
  end
  
  def update
    @strength = Strength.find(params[:id])
    if @strength.update_attributes(params[:strength])
      flash[:success] = "Strength updated."
      redirect_to user_strengths_path(@strength.user_id)
    else
      @title = "Edit strength"
      render 'edit'
    end
  end
  
  def destroy
    @strength = Strength.find(params[:id])
    @strength.destroy
    flash[:success] = "Strength removed."
    redirect_to user_strengths_path(@strength.user_id)
  end

end
