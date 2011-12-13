class NoAppraisalsController < ApplicationController
  
  def index
    @business = Business.find(session[:biz])
    @users = @business.requiring_appraisal.paginate(:page => params[:page])
    @title = "People who need a self-appraisal"
    session[:reviewreq] = "self"
  end

end
