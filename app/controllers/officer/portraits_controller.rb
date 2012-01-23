class Officer::PortraitsController < ApplicationController
  
  def show
    @application = Application.find(params[:id])
    @user = User.find(@application.user_id)
    @portrait = Portrait.find_by_user_id(@application.user_id)
    @title = "Applicant self-portrait"
    @achievements = @user.achievements.order("achievements.position")
    @characteristics = @user.characteristics.order("characteristics.position")
    @favourites = @user.favourites.order("favourites.position")
    @dislikes = @user.dislikes.order("dislikes.position")
    @qualifications = @user.qualifications.order("qualifications.position")
    @strengths = @user.strengths.order("strengths.position")
    @limitations = @user.limitations.order("limitations.position")
    @aims = @user.aims.order("aims.position")
    @referees = @user.referees
    @previousjobs = @user.previousjobs.order("previousjobs.position") 
    @no_references = @user.referees.count
  end

end
