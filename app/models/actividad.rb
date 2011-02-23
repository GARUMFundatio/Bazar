class Actividad < ActiveRecord::Base
  
  def self.graba(texto, tipo, cluster)
    
    act = Actividad.new
    
    act.desc = texto 
    act.bazar_id = cluster
    act.fecha = DateTime.now
    act.user_id = user.current_user.id
    act.local_id = 0
    
    act.save
    
  end
  
end
