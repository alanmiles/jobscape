class Reviewer::ReviewsController < ApplicationController
  
  def index
    @user = current_user
    @business = Business.find(session[:biz])
    @reviews = @user.review_requests(@business)
    @title = "Performance review requests"
  end

  def edit
    @user = current_user
    @review = Review.find(params[:id])
    @qualities = @review.reviewqualities.order("reviewqualities.position")
    @job = Job.find(@review.job_id)
    @business = Business.find(@job.business_id)
    @department = Department.find(@job.department_id)
    @grades = Reviewquality::PAM_SCORES
    @title = "Performance review"
  end
  
  def update
    @review = Review.find(params[:id])
    if @review.update_attributes(params[:review])
      
      if @review.completed?
        if @review.elements_complete?
	  
	  @review.gather_achieved_goals
          @review.calculate_achievement_scores
          
          @review.adjust_attribute_scores
         
          @review.update_attributes(:responsibilities_score => @review.score_for_responsibilities,
                                    :attributes_score => @review.score_for_qualities,
                                    :completion_date => Date.today)
          flash[:success] = "Thank you for completing the appraisal.  This is how it looks."
          redirect_to reviewer_review_path(@review)
        else
          @review.update_attribute(:completed, false)
          @qualities = @review.reviewqualities.order("reviewqualities.position")
          @job = Job.find(@review.job_id)
          @grades = Reviewquality::PAM_SCORES
          @title = "Performance review"
          flash[:error] = "You need to sign off on Responsibilities, Attributes and Comments before you can complete 
              the review.  Please continue, or save your changes without clicking the 'Completed' button"
          render 'edit'
        end
      else
        flash[:notice] = "Your changes have been saved, but there's still work to do.  You can return and complete the review any 
          time up to #{(@review.created_at + 14.days).strftime('%a %b %d, %Y')}."
        redirect_to employee_home_path
      end
    else
      @qualities = @review.reviewqualities.order("reviewqualities.position")
      @job = Job.find(@review.job_id)
      @grades = Reviewquality::PAM_SCORES
      @title = "Performance review"
      flash[:error] = "Sorry, your changes could not be accepted.  Please try again."
      render 'edit'
    end
  end
  
  def show
    @review = Review.find(params[:id])
    @job = Job.find(@review.job_id)
    @title = "Completed performance review"
    @responsibilities = @review.reviewresponsibilities.order("rating_value DESC")
    @qualities = @review.reviewqualities.order("position")
  end
  
end
