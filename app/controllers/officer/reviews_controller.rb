class Officer::ReviewsController < ApplicationController
  
  
  def index
    
  end
 
  def show
    @review = Review.find(params[:id])
    @business = Business.find(session[:biz])
    @responsibilities = @review.reviewresponsibilities.order("rating_value DESC")
    @qualities = @review.reviewqualities.order("position")
    @title = "Review details"
  end

end
