class MyTargetsController < ApplicationController
  
  
  def index
    @user = current_user
    @business = Business.find(session[:biz])
    @job = @user.current_job(@business)
    @placement = Placement.find_by_user_id_and_job_id(@user, @job)
    @targets = @placement.current_targets.paginate(:page => params[:page])
    @title = "Your current targets"
  end

  def new
    @user = current_user
    @business = Business.find(session[:biz])
    @job = @user.current_job(@business)
    @placement = Placement.find_by_user_id_and_job_id(@user, @job)
    @target = Target.new
    @target.placement_id = @placement.id
    @target.target_date = Date.today + 1.month
    @characters_left = 255
    @characters_left_note = 255
    @allow_cancel = false
    @title = "Add a target"
  end
  
  def create
    @target = Target.new(params[:target])
    if @target.save
      @date = @target.target_date.strftime("%a %b %d")
      flash[:success] = "New target to be completed by #{@date} successfully added." 
      redirect_to my_targets_path
    else
      @user = current_user
      @business = Business.find(session[:biz])
      @job = @user.current_job(@business)
      @placement = Placement.find_by_user_id_and_job_id(@user, @job)
      @target.placement_id = @placement.id
      @characters_left = 255 - @target.target.length
      @characters_left_note = 255 - @target.note.length
      @allow_cancel = false
      @title = "Add a target"
      render 'new'
    end
  end
  
  def edit
    @target = Target.find(params[:id])
    @user = current_user
    @business = Business.find(session[:biz])
    @job = @user.current_job(@business)
    @characters_left = 255 - @target.target.length
    @characters_left_note = 255 - @target.note.length
    @allow_cancel = true
    @title = "Update target" 
  end
  
  def update
    @target = Target.find(params[:id])
    if @target.update_attributes(params[:target])
      flash[:success] = "Target successfully updated"
      redirect_to my_targets_path
    else
      @user = current_user
      @business = Business.find(session[:biz])
      @job = @user.current_job(@business)
      @characters_left = 255 - @target.target.length
      @characters_left_note = 255 - @target.note.length
      @allow_cancel = true
      @title = "Update target" 
      render 'edit'
    end
  end

  def destroy
    @target = Target.find(params[:id])
    if @target.created_at < Time.now - 3.days
      flash[:error] = "Sorry, you're not allowed to delete a target entered more than 3 days ago.  To remove it from the
         list of current targets, set it as 'Cancelled' - by editing the target."
      redirect_to my_targets_path
    else
      @target.destroy
      flash[:success] = "Your target due for completion on #{@target.target_date.strftime('%b %d')} has been completely deleted."
      redirect_to my_targets_path
    end
  end
  
end
