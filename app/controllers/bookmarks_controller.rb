class BookmarksController < ApplicationController
  
  def index
    @user = current_user
    @applications = Application.bookmarks(@user).order("updated_at DESC").paginate(:page => params[:page]) 
    @title = "Your bookmarked jobs"
  end

  def edit
    @application = Application.find(params[:id])
    @vacancy = Vacancy.find(@application.vacancy_id)
    @job = Job.find(@vacancy.job_id)
    @responsibilities = @job.plan.top_five_responsibilities
    @qualities = @job.plan.top_five_attributes
    @requirements = @job.plan.top_five_requirements
    @outline = Outline.find_by_job_id(@job.id)
    @user = current_user
    @actions = Application::BOOKMARK_TYPES
    @title = "Vacancy details"
  end
  
  def update
    @application = Application.find(params[:id])
    @vacancy = Vacancy.find(@application.vacancy_id)
    if @application.update_attributes(params[:application])
      if @application.next_action == 2
        flash[:success] = "Now complete this questionnaire to complete your application."
        redirect_to edit_my_application_path(@application)
      else
        flash[:notice] = "Nothing's changed - your bookmark for Vacancy Ref ##{@vacancy.id} is still saved.  
          If you want to remove the bookmark, use the delete button on this page."
        redirect_to bookmarks_path
      end
    else
      @title = "Vacancy details"
      @job = Job.find(@vacancy.job_id)
      @responsibilities = @job.plan.top_five_responsibilities
      @qualities = @job.plan.top_five_attributes
      @requirements = @job.plan.top_five_requirements
      @outline = Outline.find_by_job_id(@job.id)
      @user = current_user
      @actions = Application::BOOKMARK_TYPES
      @title = "Vacancy details"
      flash[:error] = "Sorry, your application has not been accepted."
      render 'edit'
    end
  end
  
  def destroy
    @bookmark = Application.find(params[:id])  
    @bookmark.destroy
    flash[:success] = "Removed bookmark for vacancy ##{@bookmark.vacancy.id} - #{@bookmark.vacancy.headline}."
    redirect_to bookmarks_path
  end
end
