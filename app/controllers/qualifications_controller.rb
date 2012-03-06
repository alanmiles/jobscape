class QualificationsController < ApplicationController
  
  def index
    @user = current_user
    @qualifications = @user.qualifications.order("qualifications.position ASC")
    @title = "Qualifications"
  end

  def sort
    @user = current_user
    @qualifications = @user.qualifications
    @qualifications.each do |f|
      f.position = params['qualification'].index(f.id.to_s)+1
      f.save
    end
    render :nothing => true  
  end  
  
  def new
    @user = current_user
    @qualification = @user.qualifications.new
    @title = "New qualification"
    @characters_left = 50
  end
  
  def create
    @user = current_user
    @qualification = @user.qualifications.new(params[:qualification])
    if @qualification.save
      if @user.max_qualifications?
        flash[:success] = "Qualification successfully added - you've now entered all 5 qualifications allowed."
      else
        flash[:success] = "Qualification successfully added."
      end
      redirect_to user_qualifications_path(@user)
    else
      @title = "New qualification"
      @characters_left = 50 - @qualification.qualification.length
      @user = current_user
      render 'new'
    end
  end

  def edit
    @user = current_user
    @qualification = Qualification.find(params[:id])
    @title = "Edit qualification"
    @characters_left = 50 - @qualification.qualification.length
  end
  
  def update
    @qualification = Qualification.find(params[:id])
    if @qualification.update_attributes(params[:qualification])
      flash[:success] = "Qualification updated."
      redirect_to user_qualifications_path(@qualification.user_id)
    else
      @title = "Edit qualification"
      @characters_left = 50 - @qualification.qualification.length
      @user = current_user
      render 'edit'
    end
  end
  
  def destroy
    @qualification = Qualification.find(params[:id])
    @qualification.destroy
    flash[:success] = "Qualification removed."
    redirect_to user_qualifications_path(@qualification.user_id)
  end
end
