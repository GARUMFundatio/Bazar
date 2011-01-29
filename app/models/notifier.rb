class Notifier < ActionMailer::Base
  # TODO: cambiar al host del bazar que corresponda 
  
  default_url_options[:host] = "bazar.garumfundatio.org"
  def password_reset_instructions(user)
    subject      "Bazar: Instrucciones para cambiar la contraseña"
    from         "noresponder@bazar.com"
    recipients   user.email
    content_type "text/html"
    sent_on      Time.now
    body         :edit_password_reset_url => edit_password_reset_url(user.perishable_token)
  end
end