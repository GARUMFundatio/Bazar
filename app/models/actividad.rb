class Actividad < ActiveRecord::Base
  
  def self.graba(texto, tipo)
    
    act = Actividad.new
    
    act.desc = texto 
    act.bazar_id = ApplicationController.BZ_param("BazarId")
    act.fecha = DateTime.now
    act.user_id = user.current_user.id
    act.local_id = 0
    
    act.save
    
  end
  
end
