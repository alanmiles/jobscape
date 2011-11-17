class ReferenceChecksController < ApplicationController
  
  def new
    sign_out if signed_in?
    @title = "Reference validation"
  end
  
  def create
    @name = params[:referee][:name]
    @code = params[:referee][:access_code]
    @referee = Referee.find_by_name_and_access_code(@name, @code)
    
    if @referee.nil?
      flash.now[:error] = "Invalid email and access code combination.  Please check your invitation email and try again."
      @title = "Reference validation"
      render 'new'
    else
      @user = User.find(@referee.user_id)
      flash[:success] = "Successful sign-in.  Now please check through this self-portrait and add brief comments at the bottom."
      redirect_to edit_reference_check_path(@referee)     
    end
  end
  
  def edit
    @referee = Referee.find(params[:id])
    @user = User.find(@referee.user_id)
    @portrait = @user.portrait
    @achievements = @user.achievements.order("achievements.position")
    @characteristics = @user.characteristics.order("characteristics.position")
    @favourites = @user.favourites.order("favourites.position")
    @dislikes = @user.dislikes.order("dislikes.position")
    @qualifications = @user.qualifications.order("qualifications.position")
    @strengths = @user.strengths.order("strengths.position")
    @limitations = @user.limitations.order("limitations.position")
    @aims = @user.aims.order("aims.position")
    @previousjobs = @user.previousjobs.order("previousjobs.position")
    @ratings = Referee::RATING_TYPES
    @relationships = Referee::RELATIONSHIP_TYPES
    @title = "#{@user.name}'s self-portrait" 
  end

  def update
    @referee = Referee.find(params[:id])
    if @referee.update_attributes(params[:referee])
      if @referee.portrait_rating == 7
        @user = User.find(@referee.user_id)
        @portrait = @user.portrait
        @achievements = @user.achievements.order("achievements.position")
        @characteristics = @user.characteristics.order("characteristics.position")
        @favourites = @user.favourites.order("favourites.position")
        @dislikes = @user.dislikes.order("dislikes.position")
        @qualifications = @user.qualifications.order("qualifications.position")
        @strengths = @user.strengths.order("strengths.position")
        @limitations = @user.limitations.order("limitations.position")
        @aims = @user.aims.order("aims.position")
        @previousjobs = @user.previousjobs.order("previousjobs.position")
        @ratings = Referee::RATING_TYPES
        @relationships = Referee::RELATIONSHIP_TYPES
        @title = "#{@user.name}'s self-portrait" 
        flash[:error] = "You need to enter a rating for the portrait.  Please select one of the options
             for 'How do you rate the portrait?', then click on 'Submit' again."
        render 'edit' 
      else
        flash[:success] = "Thanks for providing this input. Now perhaps you'd like to explore
             the HYGWIT website further, using the links on this page."
        redirect_to about_path
      end
    else
      @user = User.find(@referee.user_id)
      @portrait = @user.portrait
      @achievements = @user.achievements.order("achievements.position")
      @characteristics = @user.characteristics.order("characteristics.position")
      @favourites = @user.favourites.order("favourites.position")
      @dislikes = @user.dislikes.order("dislikes.position")
      @qualifications = @user.qualifications.order("qualifications.position")
      @strengths = @user.strengths.order("strengths.position")
      @limitations = @user.limitations.order("limitations.position")
      @aims = @user.aims.order("aims.position")
      @previousjobs = @user.previousjobs.order("previousjobs.position")
      @ratings = Referee::RATING_TYPES
      @relationships = Referee::RELATIONSHIP_TYPES
      @title = "#{@user.name}'s self-portrait"
      render 'edit'
    end
  end
  
end
