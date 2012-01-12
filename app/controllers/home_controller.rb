class HomeController < ApplicationController
  layout "bazar"
  require 'dalli'
  before_filter :require_user, :only => [:index]
  
  theme "bazar"
  
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
  
  
  def queesbazar
    
    @totalempresas = Cluster.count_by_sql("select sum(empresas) from clusters where activo = 'S' ")      
    @totalbazares = Cluster.count_by_sql("select count(*) from clusters where activo = 'S' ") 
    @totalofertas = Cluster.count_by_sql("SELECT count(DISTINCT ofertasresultados.cluster_id, ofertasresultados.oferta_id) FROM ofertasresultados
    where tipo = 'O' order by cluster_id, oferta_id ") 
    @totaldemandas = Cluster.count_by_sql("SELECT count(DISTINCT ofertasresultados.cluster_id, ofertasresultados.oferta_id) FROM ofertasresultados
    where tipo = 'D' order by cluster_id, oferta_id ") 
    
    render :layout => false
  
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
      @avisos << ["Tiene pendiente evaluar a la empresa <a href='/bazarcms/empresas/#{rating.ori_empresa_id}?bazar_id=#{rating.ori_bazar_id}'>#{rating.ori_empresa_nombre}</a>", "Evaluar Ahora", "/bazarcms/evaluar/#{rating.id}",'T']
      @tareas += 1
    end 
    
    # Miramos como están los datos de la ficha de empresa primero
    
    emp = Bazarcms::Empresa.find_by_id(current_user.id)

    
    if (emp.nil?)
      @avisos << ['Debería completar los datos de su empresa', "Editar Datos de mi Empresa", "/bazarcms/empresas/#{current_user.id}/edit", 'T']
      @tareas += 1 
    else 
      # deberíamos controlar si tiene ubicaciones, sectores, si ha metido bien la url, correo, logo
      
      # comprobando si ha puesto el nombre de su empresa

      if emp.nombre =~ /^Escriba /
        @avisos << ['No parece que haya rellenado el nombre de su empresa', "Editar Datos de mi Empresa", 
          "/bazarcms/empresas/#{current_user.id}/edit", 'R', 'Si no la rellena no aparecerá en las búsquedas y perderá una buena oportunidad para promocionar su empresa y mejorar su SEO']
        @reco += 1 
      end
      
      # comprobando si ha puesto la descripción de su empresa

      if emp.desc =~ /^Describa /
        @avisos << ['No parece que haya rellenado la descripción de su empresa', "Editar Datos de mi Empresa", 
          "/bazarcms/empresas/#{current_user.id}/edit", 'R', 'Si no la rellena no aparecerá en las búsquedas y perderá una buena oportunidad para promocionar su empresa y mejorar su SEO']
        @reco += 1 
      end

      # comprobando si ha puesto la url de su empresa

      if !emp.url.nil?
        if emp.url.length <= 0 
          @avisos << ['No parece que haya rellenado la url de su empresa', "Editar Datos de mi Empresa", 
            "/bazarcms/empresas/#{current_user.id}/edit", 'R', 'Si no la rellena perderá una buena oportunidad para promocionar su empresa y las visitas a su sitio']
          @reco += 1 
        end
      else
        @avisos << ['No parece que haya rellenado la url de su empresa', "Editar Datos de mi Empresa", 
          "/bazarcms/empresas/#{current_user.id}/edit", 'R', 'Si no la rellena perderá una buena oportunidad para promocionar su empresa y las visitas a su sitio']
        @reco += 1         
      end
 
      # comprobando si ha subido el logo de su empresa

      if !emp.logo_file_name.nil?
        if emp.logo_file_name.length <= 0 
          @avisos << ['No parece que haya subido el logo de su empresa', "Editar Datos de mi Empresa", 
            "/bazarcms/empresas/#{current_user.id}/edit", 'R', 'Si sube el logo de su empresa ganará visibilidad en los resultados']
          @reco += 1 
        end
      else
        @avisos << ['No parece que haya subido el logo de su empresa', "Editar Datos de mi Empresa", 
          "/bazarcms/empresas/#{current_user.id}/edit", 'R', 'Si sube el logo de su empresa ganará visibilidad en los resultados']
        @reco += 1         
      end
 
 
      # comprobamos si ha puesto al menos una ubicación. 
      
      if Bazarcms::Ubicacion.where("empresa_id = ? ", emp.id).count <= 0
        @avisos << ['No parece que su empresa este ubicada en algún lugar', "Añadir ubicaciones de mi Empresa", 
          "/bazarcms/empresas/#{current_user.id}/edit#tabs-3", 'R', 'Muchas de las búsquedas se hacen buscando empresas en una localización determinada']
        @reco += 1 
      end
      
      # comprobamos si ha rellenado sectores 
      
      if Bazarcms::Empresasperfil.where("empresa_id = ? ", emp.id).count <= 0
        @avisos << ['No ha especificado el sector de actividad de su empresa', "Añadir Sectores de mi Empresa", 
          "/bazarcms/empresas/#{current_user.id}/edit#tabs-4", 'R', 'Muchas de las búsquedas se hacen buscando empresas de un sector de actividad determinada']
        @reco += 1 
      end
      
      # comprobamos si ha realizado alguna oferta/demanda 
      
      if Bazarcms::Oferta.where("empresa_id = ? and bazar_id = ?", emp.id, BZ_param('BazarId')).count <= 0
        @avisos << ['No ha publicado ninguna Oferta/Demanda', "Publicar una Oferta/Demanda ahora", 
          "/bazarcms/publicaroferta", 'R', 'Seguro que tiene algo que ofertar/demandar. Esto le dará visibilidad en la red de Bazares y además mejorará su SEO']
        @reco += 1 
      end
       
      
    end

    # comprobamos si ha realizado alguna oferta demanda. 

    if @avisos.count > 0
      render :layout => false 
    else 
      render :text => "", :layout => false
    end

  end 
  
end
