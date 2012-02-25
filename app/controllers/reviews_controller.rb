class ReviewsController < ApplicationController
  
  def new
    @user = current_user
    @business = Business.find(session[:biz])
    @departments = @business.current_departments
    @job = Job.find(session[:jobid])
    @placement = Placement.find_by_user_id_and_job_id_and_current(@user, @job, true)
    @review = Review.new(:reviewee_id => @user.id, :reviewer_id => @user.id, 
      		:reviewer_name => @user.name, :job_id => @job.id, :placement_id => @placement.id, :review_type => 1)
    @title = "New performance review"  
  end
  
  def create
    @review = Review.new(params[:review])
    if @review.save
      if @review.reviewer_id == @review.reviewee_id
        flash[:success] = "New self-appraisal session started"
        redirect_to edit_self_appraisal_path(@review)
      else
        @review.update_attributes(:reviewer_name => @review.reviewer.name,
                    :review_type => 2)
        flash[:success] = "#{@review.reviewer.name} has been invited to review your performance."
        redirect_to employee_home_path
      end
    else
      @user = current_user
      @business = Business.find(session[:biz])
      @departments = @business.current_departments
      @job = Job.find(session[:jobid])
      @placement = Placement.find_by_user_id_and_job_id_and_current(@user, @job, true)
      @title = "New performance review"
      render 'new'
    end
  end
  
  def reasons
    @title = "Why review?"
    
  end
  
  def reviewers
    @title = "Who should review?"
  end
  
  def frequency
    @title = "Review frequency?"
  end
  
  def time
    @title = "Time taken to review?"
  end
  
   def completed_responsibilities
    @review = Review.find(params[:id])
    @title = "Responsibility scores"
    @responsibilities = @review.reviewresponsibilities.order("position")
  end
  
  def completed_attributes
    @review = Review.find(params[:id])
    @title = "Attribute ratings"
    @qualities = @review.reviewqualities.order("position")
  end
  
  def completed_comments
    @review = Review.find(params[:id])
    @title = "Review comments"
  end
end
