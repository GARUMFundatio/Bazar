class BazarMailer < ActionMailer::Base 
  
  default :from => "admin@bazar.com" 
  
  def confirmacion_registro(user)  
    mail(:to => user.email, :subject => "Se ha registrado en Bazar")  
  end
  
  def pruebas
    mail(:from => "no-replay@garumfundatio.org", :to => "juantomas.garcia@gmail.com", :subject => "Pruebas")
  end

  def enviamensaje(de, para, asunto, texto)  
    @de = de
    @para = para
    @asunto = asunto
    @texto = texto
    
    logger.debug("Enviando correo De: #{de} a #{para} -> asunto: #{asunto}")
    
    mail(:from => de, :to => para, :subject => asunto)  
  end

end
