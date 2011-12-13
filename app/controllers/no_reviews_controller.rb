class NoReviewsController < ApplicationController
  
  def index
    @business = Business.find(session[:biz])
    @users = @business.requiring_review.paginate(:page => params[:page])
    @title = "People who need a review"
    session[:reviewreq] = "external"
  end

end
