class NotesController < ApplicationController
  
  def index
    @title = "Guidance notes"
    @notes = Note.order("title").paginate(:page => params[:page])
  end

  def show
    @title = "Note"
    if params[:id] == "0"
      @content_header = "Guidance notes"
      @content_detail = "Sorry, there's no additional help for this page."
    else
      @note = Note.find(params[:id])
      @content_header = "Notes for '#{@note.title}'"
      @content_detail = @note.content
    end
  end
  
  def new
    @title = "New note"
    @note = Note.new
  end
  
  def create
    @note = Note.new(params[:note])
    if @note.save
      flash[:success] = "The note has been successfully added to the list"
      redirect_to @note
    else
      @title = "Add a note"
      render 'new'
    end
  end
  
  def edit
    @note = Note.find(params[:id])
    @title = "Edit note"
  end
  
  def update
    @note = Note.find(params[:id])
    if @note.update_attributes(params[:note])
      flash[:success] = "Note updated."
      redirect_to @note
    else
      @title = "Edit note"
      render 'edit'
    end
  end
  
  def destroy
    @note = Note.find(params[:id]).destroy
    flash[:success] = "Note for '#{@note.title}' removed."
    redirect_to :back
  end

end
