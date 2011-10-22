class BookmarksController < ApplicationController
  
  def index
    @user = current_user
    @bookmarks = Application.bookmarks(@user).paginate(:page => params[:page]) 
    @title = "Bookmarked jobs"
  end

  def destroy
    @bookmark = Application.find(params[:id])  
    @bookmark.destroy
    flash[:success] = "Removed bookmark for vacancy ##{@bookmark.vacancy.id} - #{@bookmark.vacancy.headline}."
    redirect_to bookmarks_path
  end
end
