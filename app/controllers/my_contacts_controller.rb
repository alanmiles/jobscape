class MyContactsController < ApplicationController
  
  def edit
    @user = current_user
    @portrait = @user.portrait
    @title = "Contact details"
  end
  
  def update
    @user = current_user
    @portrait = @user.portrait
    if @portrait.update_attributes(params[:portrait])
      flash[:success] = "Your contact details have been updated"
      redirect_to user_portrait_path(@user)
    else
      @title = "Contact details"
      render 'edit'
    end
  end

end
