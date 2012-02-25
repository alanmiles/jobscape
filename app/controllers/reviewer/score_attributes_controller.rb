class Reviewer::ScoreAttributesController < ApplicationController
  
  def edit
    @review = Review.find(params[:id])
    @qualities = @review.reviewqualities.order("reviewqualities.position")
    @grades = Reviewquality::PAM_SCORES
    @title = "Rate attributes"
  end
  
  def update
    @review = Review.find(params[:id])
    if @review.update_attributes(params[:review])
      if @review.qualities_complete?
        @review.adjust_attribute_scores
        @review.update_attribute(:attributes_score, @review.score_for_qualities) 
        flash[:success] = "Attribute Ratings have been completed - with a score of #{@review.attributes_score} / 50."
      else
        flash[:notice] = "Changes have been saved, but you haven't yet finished rating Attributes."    
      end
      if @review.completed? 
        redirect_to completed_attributes_review_path(@review)
      else
        redirect_to edit_reviewer_review_path(@review)
      end
    else
      @qualities = @review.reviewqualities.order("reviewqualities.position")
      @grades = Reviewquality::PAM_SCORES
      @title = "Rate attributes"
      render 'edit'
    end
  end

end
