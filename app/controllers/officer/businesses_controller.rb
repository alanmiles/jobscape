class Officer::BusinessesController < ApplicationController

  before_filter :authenticate

  def destroy
    @business = Business.find(params[:id])
    @user = User.find(current_user.id)
    @employee = Employee.find_by_business_id_and_user_id(@business.id, @user.id)
    if @employee.officer?
      unless @business.no_associations?
        flash[:error] = "Cannot delete business while associated jobs, vacancies or employees exist"
      else
        @business.destroy
        session[:biz] = nil
        flash[:success] = "#{@business.name} removed."
      end
      redirect_to select_business_path
    else
      flash[:error] = "Illegal procedure.  You do not have permission to modify this record."
      redirect_to root_path
    end
  end
end
