class ReviewResponsesController < ApplicationController
  
  def edit
    @review = Review.find(params[:id])
    @user = current_user
    @business = Business.find(session[:biz])
    @title = "Respond to a review request"
  end
  
  def update
    @review = Review.find(params[:id])
    @user = current_user
    @user = current_user
    @business = Business.find(session[:biz])
    
    if @review.update_attributes(params[:review])
      if @review.consent == true
        flash[:success] = "You've notified #{@review.reviewee.name} that you will do the performance review shortly."
      elsif @review.consent == false
        flash[:success] = "You've notified #{@review.reviewee.name} that you won't be able to do the performance review."
      else
        flash[:notice] = "You haven't yet told #{@review.reviewee.name} whether you'll be able to do the performance review."
      end
     unless @user.has_review_requests?(@business)
        redirect_to employee_home_path
      else
        redirect_to reviewer_reviews_path
      end
    else  
      @title = "Respond to a review request"
      render 'edit'
    end
  end

end
