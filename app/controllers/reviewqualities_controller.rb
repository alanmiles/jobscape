class ReviewqualitiesController < ApplicationController
  
  
  def index
    @review = Review.find(params[:review_id])
    @qualities = @review.reviewqualities.order("reviewqualities.position")
    @title = "Review: Attributes"
  end
  
  def edit
    
  end

end
