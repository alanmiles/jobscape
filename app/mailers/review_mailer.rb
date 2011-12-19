class ReviewMailer < ActionMailer::Base

  def appraisal_notification(review, officer)
    @user = User.find(officer.id)
    @reviewee = User.find(review.reviewee_id)
    mail(:to => review.reviewee.email, :subject => "Self-appraisal reminder", :from => @user.email) 
  end
  
  def review_notification(review, officer)
    @user = User.find(officer.id)
    @reviewee = User.find(review.reviewee_id)
    @reviewer = User.find(review.reviewer_id)
    mail(:to => review.reviewee.email, :subject => "Colleague review set up for you", :from => @user.email) 
  end
  
  def reviewer_request(review, officer)
    @user = User.find(officer.id)
    @reviewee = User.find(review.reviewee_id)
    @reviewer = User.find(review.reviewer_id)
    @review = Review.find(review.id)
    mail(:to => review.reviewer.email, :subject => "HYGWIT review request", :from => @user.email) 
  end
  
end
