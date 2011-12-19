class NoReviewsController < ApplicationController
  
  def index
    @business = Business.find(session[:biz])
    @users = @business.requiring_review.paginate(:page => params[:page])
    @title = "People who need a review"
    session[:reviewreq] = "external"
  end

  def edit
    @reviewee = User.find(params[:id])
    session[:reviewee] = @reviewee.id
    redirect_to new_officer_review_path
  end
end
