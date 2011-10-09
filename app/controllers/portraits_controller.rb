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
    @characteristics = @user.characteristics.order("characteristics.position")
    @favourites = @user.favourites.order("favourites.position")
    @dislikes = @user.dislikes.order("dislikes.position")
    @qualifications = @user.qualifications.order("qualifications.position")
    @strengths = @user.strengths.order("strengths.position")
    @limitations = @user.limitations.order("limitations.position")
    @aims = @user.aims.order("aims.position")
  end

end
