class BazarMailer < ActionMailer::Base
  # TODO hay que meterlo en uno de los parametros de la configuracion  
  
  default :from => "admin@bazar.com" 
  
  def confirmacion_registro(user)  
    mail(:to => user.email, :subject => "Registered")  
  end

end
