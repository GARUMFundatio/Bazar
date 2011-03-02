class Actividad < ActiveRecord::Base
  
  def self.graba(texto, tipo, cluster, user, nombre_empresa)
    
    act = Actividad.new
    
    act.desc = texto 
    act.bazar_id = cluster
    act.fecha = DateTime.now
    act.user_id = user
    act.nombre_empresa = nombre_empresa
    act.tipo = tipo
    act.local_id = 0
    
    act.save
    
  end
  
end
