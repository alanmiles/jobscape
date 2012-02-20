class NoAppraisalsController < ApplicationController
  
  def index
    @business = Business.find(session[:biz])
    @users = @business.requiring_appraisal.paginate(:page => params[:page])
    @title = "Self-appraisals due"
    session[:reviewreq] = "self"
  end

end
