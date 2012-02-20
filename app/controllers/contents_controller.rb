class ContentsController < ApplicationController
  
  def index
    @title = "Page contents"
    @contents = Content.order("header").paginate(:per_page => 20, :page => params[:page])
  end

  def show
    @title = "Content"
    @content = Content.find(params[:id])
    @content_header = "Content for '#{@content.header}'"
    @content_detail = @content.content
    
  end
  
  def new
    @title = "New content"
    @content = Content.new
  end
  
  def create
    @content = Content.new(params[:content])
    if @content.save
      flash[:success] = "The page content has been successfully added"
      redirect_to @content
    else
      @title = "New content"
      render 'new'
    end
  end
  
  def edit
    @content = Content.find(params[:id])
    @title = "Edit content"
  end
  
  def update
    @content = Content.find(params[:id])
    if @content.update_attributes(params[:content])
      flash[:success] = "Content updated."
      redirect_to @content
    else
      @title = "Edit content"
      render 'edit'
    end
  end
  
  def destroy
    @content = Content.find(params[:id]).destroy
    flash[:success] = "Content for '#{@content.header}' removed."
    redirect_to :back
  end


end
