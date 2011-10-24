module ApplicationsHelper

  def instructions
    if signed_in?
      unless current_user.has_public_portrait? 
        return "You need to create a Self-Portrait and make it public before applying for this job" 
      else
        unless @vacancy.interest_from?(current_user)
          return "At the bottom of this page, you can bookmark or apply for the job."
        else
          if @vacancy.application_from(current_user).next_action == 0
            return "At the bottom of this page, you can bookmark or apply for the job."
          elsif @vacancy.application_from(current_user).next_action == 1
            return "You've already bookmarked this job.  Use the button at the bottom of this page to apply now."
          else 
            return "You've already applied for this job."
          end
        end
      end
    else
      return "Sign up for a free HYGWIT account, and you can start applying for jobs like this."
    end
  end
end
