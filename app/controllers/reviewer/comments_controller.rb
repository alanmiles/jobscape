class Reviewer::CommentsController < ApplicationController
  
  def edit
    @review = Review.find(params[:id])
    @title = "Reviewer comments"
    if @review.achievements.nil? 
      @achievement_characters_left = 255
    else
      @achievement_characters_left = 255 - @review.achievements.length
    end
    if @review.problems.nil? 
      @problem_characters_left = 255
    else
      @problem_characters_left = 255 - @review.problems.length
    end
    if @review.observations.nil? 
      @observation_characters_left = 255
    else
      @observation_characters_left = 255 - @review.observations.length
    end
    if @review.change_responsibilities.nil? 
      @change_responsibility_characters_left = 255
    else
      @change_responsibility_characters_left = 255 - @review.change_responsibilities.length
    end
    if @review.change_goals.nil? 
      @change_goal_characters_left = 255
    else
      @change_goal_characters_left = 255 - @review.change_goals.length
    end
    if @review.change_attributes.nil? 
      @change_attribute_characters_left = 255
    else
      @change_attribute_characters_left = 255 - @review.change_attributes.length
    end
    if @review.plan.nil? 
      @plan_characters_left = 255
    else
      @plan_characters_left = 255 - @review.plan.length
    end
  end
  
  def update
    @review = Review.find(params[:id])
    if @review.update_attributes(params[:review])
      if @review.comments_complete?
        flash[:success] = "Comments are now complete."
      else
        flash[:notice] = "Changes have been saved, but you didn't check the box to say you've finished adding comments."    
      end
      if @review.completed? 
        redirect_to completed_comments_review_path(@review)
      else
        redirect_to edit_reviewer_review_path(@review)
      end
    else
      @title = "Reviewer comments"
      if @review.achievements.nil? 
        @achievement_characters_left = 255
      else
        @achievement_characters_left = 255 - @review.achievements.length
      end
      render 'edit'
      if @review.problems.nil? 
        @problem_characters_left = 255
      else
        @problem_characters_left = 255 - @review.problems.length
      end
      if @review.observations.nil? 
        @observation_characters_left = 255
      else
        @observation_characters_left = 255 - @review.observations.length
      end
      if @review.change_responsibilities.nil? 
        @change_responsibility_characters_left = 255
      else
        @change_responsibility_characters_left = 255 - @review.change_responsibilities.length
      end
      if @review.change_goals.nil? 
        @change_goal_characters_left = 255
      else
        @change_goal_characters_left = 255 - @review.change_goals.length
      end
      if @review.change_attributes.nil? 
        @change_attribute_characters_left = 255
      else
        @change_attribute_characters_left = 255 - @review.change_attributes.length
      end
      if @review.plan.nil? 
        @plan_characters_left = 255
      else
        @plan_characters_left = 255 - @review.plan.length
      end
    end
  end

end
