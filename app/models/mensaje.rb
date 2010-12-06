class Mensaje < ActiveRecord::Base
  
  scope :notificacionessinleer, lambda { |user|
      where("mensajes.leido IS NULL AND mensajes.borrado is NULL AND mensajes.tipo = 'N' and mensajes.para = ?", user)
    }  
  
  scope :notificacionestotal, lambda { |user|
      where("mensajes.borrado IS NULL AND mensajes.tipo = 'N' and mensajes.para = ?", user)
      }
      
  scope :mensajessinleer, lambda { |user|
      where("mensajes.leido IS NULL AND mensajes.borrado is NULL AND mensajes.tipo = 'M' and mensajes.para = ?", user)
    }  

  scope :mensajestotal, lambda { |user|
      where("mensajes.borrado IS NULL AND mensajes.tipo = 'M' and mensajes.para = ?", user)
      }
      
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
