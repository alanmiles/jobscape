class FavouritesController < ApplicationController
  
  def index
    @user = current_user
    @favourites = @user.favourites.order("favourites.position")
    @title = "My favourite things"
  end

  def sort
    @user = current_user
    @user.favourites.each do |f|
      f.position = params["favourite"].index(f.id.to_s)+1
      f.save
    end
    render :nothing => true  
  end  
  
  def new
    @user = current_user
    @favourite = @user.favourites.new
    @title = "Add a favourite"
    @characters_left = 50
  end
  
  def create
    @user = current_user
    @favourite = @user.favourites.new(params[:favourite])
    if @favourite.save
      if @user.max_favourites?
        flash[:success] = "Favourite successfully added - you've now entered all 5 favourites allowed."
      else
        flash[:success] = "Favourite successfully added."
      end
      redirect_to user_favourites_path(@user)
    else
      @title = "Add a favourite"
      @characters_left = 50 - @favourite.favourite.length
      @user = current_user
      render 'new'
    end
  end

  def edit
    @user = current_user
    @favourite = Favourite.find(params[:id])
    @title = "Edit favourite"
    @characters_left = 50 - @favourite.favourite.length
  end
  
  def update
    @favourite = Favourite.find(params[:id])
    if @favourite.update_attributes(params[:favourite])
      flash[:success] = "Favourite updated."
      redirect_to user_favourites_path(@favourite.user_id)
    else
      @title = "Edit favourite"
      @characters_left = 50 - @favourite.favourite.length
      @user = current_user
      render 'edit'
    end
  end
  
  def destroy
    @favourite = Favourite.find(params[:id])
    @favourite.destroy
    flash[:success] = "Favourite removed."
    redirect_to user_favourites_path(@favourite.user_id)
  end

end
