module UsersHelper

  def gravatar_for(user, options = { :size => 50 })
    gravatar_image_tag(user.email.downcase, :alt => user.name,
                                            :class => 'gravatar',
                                            :gravatar => options)
  end
  
  def account_explanation
    if @user.account == 2
      "This account is intended for people who are not currently employed.  Use HYGWIT's unique job-search
       and CV tools to land the job you've been waiting for."
    elsif @user.account == 3
      "Use this account to boost achievement across your whole business. Use the unique HYGWIT tools for recruitment, appraisal,
       training needs analysis, job evaluation, succession planning - and let everyone join in."
    elsif @user.account == 4
      "This is the account to use if your business is already using HYGWIT, and you've been asked to participate.  Someone in
       the business should have let you know your Personal Identity Number."
    else
      "You're employed, and HYGWIT isn't yet part of your business.  Use our achievement tools to help
      you stand out from the crowd, no matter what your job."
    end
  end
  
end
