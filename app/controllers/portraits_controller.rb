class PortraitsController < ApplicationController
  
  
  def edit
    @user = current_user
    @portrait = @user.portrait
    @title = "Edit self-portrait"
    if @portrait.notes == nil
      @characters_left = 200
    else
      @characters_left = 200 - @portrait.notes.length
    end
  end
  
  def update
    @user = current_user
    @portrait = @user.portrait
    if @portrait.update_attributes(params[:portrait])
      if @portrait.right_to_work == false
        @portrait.update_attribute(:public, false)
        flash[:notice] = "Sorry, we won't be able to help you if you don't have the legal right to work in this country.  Your Portrait will not be public."
      elsif @portrait.public == false
        flash[:success] = "Portrait updated, but at your request, it won't be shown to employers yet."
      else
        if @user.count_referees >= 2
          
          #Email references if they haven't already been notified
          @referees = @user.referees
          @referees.each do |referee|
            if referee.access_code.nil? || referee.access_code.empty?
              @code = Referee.generate_code
              referee.update_attribute(:access_code, @code)
              RefereeMailer.request_response(referee).deliver
            end
          end
          
          flash[:success] = "Portrait updated, and can now be viewed by potential employers."
          
        else
          @portrait.update_attribute(:public, false)
          flash[:notice] = "Sorry, you can't make your Portrait public until you've entered at least two references."
        end
      end
      redirect_to user_portrait_path(@portrait.user_id)
    else
      @title = "Edit self-portrait"
      render 'edit'
    end
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
    @referees = @user.referees
    @previousjobs = @user.previousjobs.order("previousjobs.position") 
  end

end
