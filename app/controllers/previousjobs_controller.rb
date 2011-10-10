class PreviousjobsController < ApplicationController
  
  def index
    @user = current_user
    @previousjobs = @user.previousjobs.order("previousjobs.position")
    @title = "Previous jobs"
  end

  def sort
    @user = current_user
    @user.previousjobs.each do |f|
      f.position = params["previousjob"].index(f.id.to_s)+1
      f.save
    end
    render :nothing => true  
  end  
  
  def new
    @user = current_user
    @previousjob = @user.previousjobs.new
    @title = "Add a previous job"
  end
  
  def create
    @user = current_user
    @previousjob = @user.previousjobs.new(params[:previousjob])
    if @previousjob.save
      if @user.max_previousjobs?
        flash[:success] = "Job successfully added - you've now entered all 3 previous jobs allowed."
      else
        flash[:success] = "Job successfully added."
      end
      redirect_to user_previousjobs_path(@user)
    else
      @title = "Add a previous job"
      render 'new'
    end
  end

  def edit
    @user = current_user
    @previousjob = Previousjob.find(params[:id])
    @title = "Edit job"
  end
  
  def update
    @previousjob = Previousjob.find(params[:id])
    if @previousjob.update_attributes(params[:previousjob])
      flash[:success] = "Job updated."
      redirect_to user_previousjobs_path(@previousjob.user_id)
    else
      @title = "Edit job"
      render 'edit'
    end
  end
  
  def destroy
    @previousjob = Previousjob.find(params[:id])
    @previousjob.destroy
    flash[:success] = "#{@previousjob.job} removed."
    redirect_to user_previousjobs_path(@previousjob.user_id)
  end
  
end

