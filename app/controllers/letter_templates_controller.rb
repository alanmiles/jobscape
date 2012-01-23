class LetterTemplatesController < ApplicationController
  
  def index
    @letter_templates = LetterTemplate.all
    @title = "Letter templates"
  end

  def new
    @title = "New letter template"
    @letter_template = LetterTemplate.new
    @characters_left = 750
  end
  
  def create
    @letter_template = LetterTemplate.new(params[:letter_template])
    if @letter_template.save
      flash[:success] = "Template successfully saved"
      redirect_to letter_templates_path
    else
      @title = "New letter template"
      @characters_left = 750 - @letter_template.content.length
      render "new"
    end
  end
  
  def show
    @letter_template = LetterTemplate.find(params[:id])
    @title = "Letter template"
  end
  
  def edit
    @letter_template = LetterTemplate.find(params[:id])
    @title = "Edit letter template"
    @characters_left = 750 - @letter_template.content.length
  end
  
  def update
    @letter_template = LetterTemplate.find(params[:id])
    if @letter_template.update_attributes(params[:letter_template])
      flash[:success] = "Template updated."
      redirect_to letter_template_path(@letter_template)
    else
      @title = "Edit letter template"
      @characters_left = 750 - @letter_template.content.length
      render 'edit'
    end
  end

end
