ActionMailer::Base.smtp_settings = {  
  :address              => "localhost",  
  :port                 => 25,  
  :domain               => "garumfundatio.org",  
#  :user_name            => "juantomas",  
#  :password             => "secret",  
#  :authentication       => "plain",  
  :enable_starttls_auto => false  
}