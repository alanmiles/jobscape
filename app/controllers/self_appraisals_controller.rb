class SelfAppraisalsController < ApplicationController
  
  def index
    @user = current_user
    @job = Job.find(session[:jobid])
    @reviews = Review.where("reviewee_id = ? and completed = ?", @user.id, true)
    @title = "Your review history"
  end
  
  def new
    @user = current_user
    @job = Job.find(session[:jobid])
    @placement = Placement.find_by_user_id_and_job_id_and_current(@user, @job, true)
    @review = Review.new(:reviewee_id => @user.id, :reviewer_id => @user.id, 
    		:reviewer_name => @user.name, :job_id => @job.id, :placement_id => @placement.id)
    @title = "New performance review"    
  end
  
  def create
    @review = Review.new(params[:review])
    if @review.save
      flash[:success] = "New review session started"
      redirect_to edit_self_appraisal_path(@review)
    else
      @user = current_user
      @job = Job.find(session[:jobid])
      @placement = Placement.find_by_user_id_and_job_id_and_current(@user, @job, true)
      #@review = Review.new(:reviewee_id => @user.id, :reviewer_id => @user.id, :reviewer_name => @user.name, :job_id => @job.id)
      @title = "New performance review"
      render 'new'
    end
  end
  
  def edit
    @review = Review.find(params[:id])
    @qualities = @review.reviewqualities.order("reviewqualities.position")
    @job = Job.find(@review.job_id)
    @grades = Reviewquality::PAM_SCORES
    if @review.self_appraisal?
      @title = "Self-appraisal for #{current_user.name}"
    else
      @title = "Review for #{current_user.name}"
    end
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
                                    :completion_date => Time.now)
          flash[:success] = "Well done - you've completed your self-appraisal.  This is how it looks."
          redirect_to self_appraisal_path(@review)
        else
          @review.update_attribute(:completed, false)
          @qualities = @review.reviewqualities.order("reviewqualities.position")
          @job = Job.find(@review.job_id)
          @grades = Reviewquality::PAM_SCORES
          if @review.self_appraisal?
            @title = "Self-appraisal for #{current_user.name}"
          else
            @title = "Review for #{current_user.name}"
          end
          flash[:error] = "You need to sign off on Responsibilities, Attributes and Comments before you can complete 
              the review.  Please continue, or save your changes without clicking the 'Completed' button"
          render 'edit'
        end
      else
        flash[:notice] = "Your changes have been saved, but there's still work to do.  You can return and complete the review any 
          time up to #{(@review.created_at + 14.days).strftime('%a %b %d, %Y')}."
        if current_user.account >= 3
          redirect_to employee_home_path
        else
          redirect_to my_job_path
        end
      end
    else
      @qualities = @review.reviewqualities.order("reviewqualities.position")
      @job = Job.find(@review.job_id)
      @grades = Reviewquality::PAM_SCORES
      if @review.self_appraisal?
        @title = "Self-appraisal for #{current_user.name}"
      else
        @title = "Review for #{current_user.name}"
      end
      flash[:error] = "Sorry, your changes could not be accepted.  Please try again."
      render 'edit'
    end
  
  end

  def show
    @review = Review.find(params[:id])
    @job = Job.find(session[:jobid])
    @title = "Your self-appraisal"
    @responsibilities = @review.reviewresponsibilities.order("rating_value DESC")
    @qualities = @review.reviewqualities.order("position")
  end
end
