ActionMailer::Base.smtp_settings = {  
      :address              => "smtp.gmail.com",  
      :port                 => 587,  
      :domain               => "gmail.com",  
      :user_name            => "alanpqs",  
      :password             => "nelim3sala",  
      :authentication       => "plain",  
      :enable_starttls_auto => true  
    }  
    
    require "development_mail_interceptor"
    
    #if Rails.env.production?
    #  ActionMailer::Base.default_url_options[:host] = ""
    #else

    ActionMailer::Base.default_url_options[:host] = "localhost:3000" 
    #end
    
    Mail.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development? 
