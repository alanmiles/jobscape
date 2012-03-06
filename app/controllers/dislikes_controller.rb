class DislikesController < ApplicationController
  
  def index
    @user = current_user
    @dislikes = @user.dislikes.order("dislikes.position")
    @title = "Dislikes"
  end

  def sort
    @user = current_user
    @user.dislikes.each do |f|
      f.position = params["dislike"].index(f.id.to_s)+1
      f.save
    end
    render :nothing => true  
  end  
  
  def new
    @user = current_user
    @dislike = @user.dislikes.new
    @title = "New dislike"
    @characters_left = 50
  end
  
  def create
    @user = current_user
    @dislike = @user.dislikes.new(params[:dislike])
    if @dislike.save
      if @user.max_dislikes?
        flash[:success] = "Dislike successfully added - you've now entered all 5 dislikes allowed."
      else
        flash[:success] = "Dislike successfully added."
      end
      redirect_to user_dislikes_path(@user)
    else
      @title = "New dislike"
      @characters_left = 50 - @dislike.dislike.length
      @user = current_user
      render 'new'
    end
  end

  def edit
    @user = current_user
    @dislike = Dislike.find(params[:id])
    @characters_left = 50 - @dislike.dislike.length
    @title = "Edit dislike"
  end
  
  def update
    @dislike = Dislike.find(params[:id])
    if @dislike.update_attributes(params[:dislike])
      flash[:success] = "Dislike updated."
      redirect_to user_dislikes_path(@dislike.user_id)
    else
      @title = "Edit dislike"
      @characters_left = 50 - @dislike.dislike.length
      @user = current_user
      render 'edit'
    end
  end
  
  def destroy
    @dislike = Dislike.find(params[:id])
    @dislike.destroy
    flash[:success] = "Dislike removed."
    redirect_to user_dislikes_path(@dislike.user_id)
  end
end
