class Mensaje < ActiveRecord::Base
  
  def self.envianotificicacion(de, asunto, texto)

    for usu in User.all
    
      men = self.new
    
      men.fecha = DateTime.now
      men.de = de
      men.para = usu.id
      men.asunto = asunto
      men.texto = texto
      men.tipo = 'N'

      men.save
    
    end 
    
  end
  
end
