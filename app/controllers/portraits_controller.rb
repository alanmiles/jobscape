class PortraitsController < ApplicationController
  
  
  def edit
    @user = current_user
    @portrait = @user.portrait
    @title = "Edit self-portrait"
  end

  def show
    @user = current_user
    @portrait = @user.portrait
    @title = "Self-portrait"
    @achievements = @user.achievements.order("achievements.position")
  end

end
