class DislikesController < ApplicationController
  
  def index
    @user = current_user
    @dislikes = @user.dislikes.order("dislikes.position")
    @title = "I get mad when ..."
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
    @title = "Add something that annoys you"
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
      @title = "Add something that annoys you"
      render 'new'
    end
  end

  def edit
    @user = current_user
    @dislike = Dislike.find(params[:id])
    @title = "Edit dislike"
  end
  
  def update
    @dislike = Dislike.find(params[:id])
    if @dislike.update_attributes(params[:dislike])
      flash[:success] = "Dislike updated."
      redirect_to user_dislikes_path(@dislike.user_id)
    else
      @title = "Edit dislike"
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
