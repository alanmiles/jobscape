module UsersHelper

  def gravatar_for(user, options = { :size => 50 })
    gravatar_image_tag(user.email.downcase, :alt => user.name,
                                            :class => 'gravatar',
                                            :gravatar => options)
  end
  
  def account_explanation
    if @user.admin?
      "You're also one of our HYGIT admins.  To give yourself the widest possible range of options - including taking an administrative
       role with our client companies when invited, you should opt for a business account."
    else
      if @user.account == 2
        "This account gives you access to HYGWIT's job-search
         and CV tools to land the job you've been waiting for."
      elsif @user.account == 3
        "As well as tracking your own performance, you can use this account to boost achievement across your whole business. 
         Use the unique HYGWIT tools for recruitment, appraisal,
         training needs analysis, job evaluation, succession planning - and let everyone join in."
      elsif @user.account == 4
        "Your business is already using HYGWIT, and you've been asked to participate. Your Achievement Plan will show you 
         exactly what management expects from you.  Meet and beat your targets, then aim even higher and you'll be a star.  
         Privately, you can also set a route-map for your personal goals and measure your progress."
      else
        "HYGWIT isn't yet part of your business, but you can use our achievement tools to help
         you stand out from the crowd, no matter what your job.  You'll also have access to HYGWIT's job-search tools in case
         you feel its time for a change."
      end
    end
  end
  
end
