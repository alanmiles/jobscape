class AchievementsController < ApplicationController
  
  
  def index
    @user = current_user
    @achievements = @user.achievements.order("achievements.position")
    @title = "Achievements"
  end

  def sort
    @user = current_user
    @achievements = @user.achievements
    @achievements.each do |f|
      f.position = params['achievement'].index(f.id.to_s)+1
      f.save
    end
    render :nothing => true  
  end  
  
  def new
    @user = current_user
    @achievement = @user.achievements.new
    @title = "Add an achievement"
    @characters_left = 200
  end
  
  def create
    @user = current_user
    @achievement = @user.achievements.new(params[:achievement])
    if @achievement.save
      if @user.max_achievements?
        flash[:success] = "Achievement successfully added - you've now entered all 3 achievements allowed."
      else
        flash[:success] = "Achievement successfully added."
      end
      redirect_to user_achievements_path(@user)
    else
      @title = "Add an achievement"
      @characters_left = 200 - @achievement.achievement.length
      @user = current_user
      render 'new'
    end
  end

  def edit
    @achievement = Achievement.find(params[:id])
    @title = "Edit achievement"
    @characters_left = 200 - @achievement.achievement.length
  end
  
  def update
    @achievement = Achievement.find(params[:id])
    if @achievement.update_attributes(params[:achievement])
      flash[:success] = "Achievement updated."
      redirect_to user_achievements_path(@achievement.user_id)
    else
      @title = "Edit achievement"
      @characters_left = 200 - @achievement.achievement.length
      @user = current_user
      render 'edit'
    end
  end
  
  def destroy
    @achievement = Achievement.find(params[:id])
    @achievement.destroy
    flash[:success] = "Achievement removed."
    redirect_to user_achievements_path(@achievement.user_id)
  end

end
