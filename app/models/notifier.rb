class Notifier < ActionMailer::Base
  # TODO: cambiar al host del bazar que corresponda 
  
  default_url_options[:host] = "" # ApplicationController.BZ_param("BazarId")
  
  def password_reset_instructions(user, hostname)
    default_url_options[:host] = hostname
    subject      "Bazar: Instrucciones para cambiar la contraseña"
    from         "noresponder@bazar.garumfundatio.org"
    recipients   user.email
    content_type "text/html"
    sent_on      Time.now
    body         :edit_password_reset_url => edit_password_reset_url(user.perishable_token)
  end
  
end