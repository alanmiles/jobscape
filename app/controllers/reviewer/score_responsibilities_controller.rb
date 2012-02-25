class Reviewer::ScoreResponsibilitiesController < ApplicationController
  
  def edit
    @review = Review.find(params[:id])
    @title = "Score responsibilities"
  end
  
  def update
    @review = Review.find(params[:id])
    if @review.update_attributes(params[:review])
      if @review.responsibilities_complete?
        @review.gather_achieved_goals
        @review.calculate_achievement_scores
        @review.update_attribute(:responsibilities_score, @review.score_for_responsibilities) 
        flash[:success] = "Responsibility scoring has been completed - with a score of #{@review.responsibilities_score} / 50."
      else
        flash[:notice] = "Changes have been saved, but you haven't yet completed scoring Responsibilities."    
      end
      if @review.completed? 
        redirect_to completed_responsibilities_review_path(@review)
      else
        redirect_to edit_reviewer_review_path(@review)
      end
    else
      @title = "Score responsibilities"
      render 'edit'
    end
  end

end
