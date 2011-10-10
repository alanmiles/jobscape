class ReferencesController < ApplicationController
  
  def index
    @user = current_user
    @references = @user.references
    @title = "References"
  end

  def new
    @user = current_user
    @reference = @user.references.new
    @title = "Add a reference"
    @relationships = Reference::RELATIONSHIP_TYPES
  end
  
  def create
    @user = current_user
    @reference = @user.references.new(params[:reference])
    if @reference.save
      if @user.max_references?
        flash[:success] = "Reference successfully added - you've now entered all 3 references allowed."
      else
        flash[:success] = "Reference successfully added."
      end
      redirect_to user_references_path(@user)
    else
      @title = "Add a reference"
      @relationships = Reference::RELATIONSHIP_TYPES
      render 'new'
    end
  end

  def edit
    @user = current_user
    @reference = Reference.find(params[:id])
    @title = "Edit reference"
    @relationships = Reference::RELATIONSHIP_TYPES
  end
  
  def update
    @reference = Reference.find(params[:id])
    if @reference.update_attributes(params[:reference])
      flash[:success] = "Reference updated."
      redirect_to user_references_path(@reference.user_id)
    else
      @title = "Edit reference"
      @relationships = Reference::RELATIONSHIP_TYPES
      render 'edit'
    end
  end
  
  def destroy
    @reference = Reference.find(params[:id])
    @reference.destroy
    flash[:success] = "#{@reference.name} removed from list."
    redirect_to user_references_path(@reference.user_id)
  end

end
