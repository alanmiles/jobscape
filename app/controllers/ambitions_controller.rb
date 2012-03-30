class AmbitionsController < ApplicationController
  def index
    @user = current_user
    @ambitions = @user.ambitions
    @title = "My ambitions"
  end

  def new
    @user = current_user
    @ambition = @user.ambitions.new
    @title = "New ambition"
    @characters_left = 100
  end
  
  def create
    @user = current_user
    @ambition = @user.ambitions.new(params[:ambition])
    if @ambition.save
      if @user.max_ambitions?
        flash[:success] = "Ambition successfully added - you've now entered all 5 ambitions."
      else
        flash[:success] = "Ambition successfully added."
      end
      redirect_to user_ambitions_path(@user)
    else
      @title = "New ambition"
      @characters_left = 100 - @ambition.ambition.length
      @user = current_user
      render 'new'
    end
  end
  
  def show
    @user = current_user
    @ambition = Ambition.find(params[:id])
    @title = "Ambition"
  end

  def destroy
    @ambition = Ambition.find(params[:id])
    @ambition.destroy
    flash[:success] = "Ambition removed."
    redirect_to user_ambitions_path(@ambition.user_id)
  end
end
