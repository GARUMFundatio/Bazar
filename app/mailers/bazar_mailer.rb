class BazarMailer < ActionMailer::Base 
  
  default :from => "admin@bazar.com" 
  
  def confirmacion_registro(user)  
    mail(:to => user.email, :subject => "Se ha registrado en Bazar")  
  end
  
  def pruebas
    mail(:from => "no-replay@garumfundatio.org", :to => "juantomas.garcia@gmail.com", :subject => "Pruebas")
  end

end
