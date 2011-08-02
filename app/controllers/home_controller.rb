class HomeController < ApplicationController
  layout "bazar"
    require 'dalli'
  before_filter :require_user, :only => [:index]
  
  # homepage de usuario 
  
  def index
    
    
  end

  # homepage de bazar 
  
  def home    

    # compruebo si está logueado. 
    
    if !current_user.nil?
      # le mandamos a la página de usuario
      
      render :action => "index"
    end

    @total = Cluster.count_by_sql("select sum(empresas) from clusters")      

    # TODO: comprobar si esto sobra 
    
    @ultimas = Bazarcms::Empresa.ultimascreadas
    @actualizadas = Bazarcms::Empresa.ultimasactualizadas

  end 

  def datos 


  end 

  def open 

    render :layout => false
    
  end 
  
  def avisos 
  
    @avisos = Array.new
 
    @reco = 0 
    @tareas = 0 
    
    # Comprobamos si tiene ratings pendientes de actualizar
    
    ratings = Bazarcms::Rating.where('des_bazar_id = ? and des_empresa_id = ? and des_fecha is null', BZ_param('BazarId'), current_user.id)

    logger.debug "Ratings Pendientes: #{ratings.inspect}"
    
    for rating in ratings 
      @avisos << ["Tiene pendiente evaluar a la empresa <a href='/bazarcms/empresas/#{rating.ori_empresa_id}?bazar_id=#{rating.ori_bazar_id}'>#{rating.ori_empresa_nombre}</a>", "Evaluar Ahora", "/bazarcms/evaluar/#{rating.id}"]
      @tareas += 1
    end 
    
    # Miramos como están los datos de la ficha de empresa primero
    
    emp = Bazarcms::Empresa.find_by_id(current_user.id)

    
    if (emp.nil?)
      @avisos << ['Debería completar los datos de su empresa', "Editar Datos de mi Empresa", "/bazarcms/empresas/#{current_user.id}/edit"]
      @tareas += 1 
    else 
      # deberíamos controlar si tiene ubicaciones, sectores, si ha metido bien la url, correo, logo
    end

    # comprobamos si ha realizado alguna oferta demanda. 

    if @avisos.count > 0
      render :layout => false 
    else 
      render :text => "", :layout => false
    end

  end 
  
end
