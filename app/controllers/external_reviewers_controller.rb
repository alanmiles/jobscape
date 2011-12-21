class ExternalReviewersController < ApplicationController
  
  def edit
    @review = Review.find(params[:id])
    @user = current_user
    if @review.reviewer_name.empty? || @review.reviewer_name == @user.name
      @contact = @review.reviewer_email
      @full_contact_details = @review.reviewer_email
    else
      @contact = @review.reviewer_name
      @full_contact_details = "#{@review.reviewer_name} - #{@review.reviewer_email}"
    end
    @business = Business.find(session[:biz])
    @title = "Your current review plan"
  end
  
  def update
    @review = Review.find(params[:id])
    if @review.reviewer_name.empty? || @review.reviewer_name == current_user.name
      @contact = @review.reviewer_email
    else
      @contact = @review.reviewer_name
    end
    
    if @review.update_attributes(params[:review])
      if @review.cancel == true
        flash[:notice] = "The planned review by #{@contact} has now been cancelled."
      else
        if @review.consent == false
          flash[:notice] = "You didn't confirm that you've seen the previous form, so the review has not yet
                      been cancelled.  This prevents you from setting up a new review."
        else
          flash[:success] = "Any changes you made to your current review have been recorded.
                         The reviewer is #{@contact}."
        end
      end
      redirect_to my_job_path
    else
      @user = current_user
      @business = Business.find(session[:biz])
      @title = "Your current review plan"
      render 'edit'
    end
  end

end
