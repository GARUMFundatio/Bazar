class HomeController < ApplicationController
  layout "bazar"
  require 'dalli'
  before_filter :require_user, :only => [:index]
  
  theme "bazar"
  
  # homepage de usuario 
  
  def index
    
    @totalempresas = Bazarcms::Empresa.count_by_sql("select count(*) from empresas")      
    @totalbazares = Cluster.count_by_sql("select count(*) from clusters where activo = 'S' ") 
    @totalofertas = Bazarcms::Oferta.count_by_sql("SELECT count(*) FROM ofertas where tipo = 'O' ") 
    @totaldemandas = Bazarcms::Oferta.count_by_sql("SELECT count(*) FROM ofertas where tipo = 'D' ")
    
    @ofertas = Bazarcms::Oferta.where("tipo = 'O'").order("fecha desc")
    @demandas = Bazarcms::Oferta.where("tipo = 'D'").order("fecha desc")
    
    miempresa = Bazarcms::Empresa.find(current_user.id)

    if (!miempresa.nil?) 
      if !miempresa.interesantes.nil?
        @empresasrecomendadas = Bazarcms::Empresa.where("id in (?) ", miempresa.interesantes).limit(18)
      end
    else 
      @empresasrecomendadas = nil      
    end

    @empresasrecientes = Bazarcms::Empresa.where("  nombre not like 'Escriba%' ").order("created_at desc").limit(9) #created_at BETWEEN (CURDATE() - INTERVAL 30 DAY) AND CURDATE() and nombre not like 'Escriba%' ")

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
    
    clusters = Cluster.where("activo = 'S' and id > 1").order("empresas desc")
    
    @clusters = []
    
    for cluster in clusters
      lin = []
      lin << cluster.nombre
      lin << cluster.empresas
      lin << Cluster.count_by_sql("SELECT count(DISTINCT ofertasresultados.cluster_id, ofertasresultados.oferta_id) FROM ofertasresultados
      where tipo = 'O' and cluster_id = #{cluster.id} order by cluster_id, oferta_id ")
      lin << Cluster.count_by_sql("SELECT count(DISTINCT ofertasresultados.cluster_id, ofertasresultados.oferta_id) FROM ofertasresultados
      where tipo = 'D' and cluster_id = #{cluster.id} order by cluster_id, oferta_id ")
      lin << cluster.url
      @clusters << lin
    end
    
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
   
  def dashboardbazar 

    @totalempresas = Bazarcms::Empresa.count_by_sql("select count(*) from empresas")      
    @totalbazares = Cluster.count_by_sql("select count(*) from clusters where activo = 'S' ") 
    @totalofertas = Bazarcms::Oferta.count_by_sql("SELECT count(*) FROM ofertas where tipo = 'O' ") 
    @totaldemandas = Bazarcms::Oferta.count_by_sql("SELECT count(*) FROM ofertas where tipo = 'D' ")

    respond_to do |format|
      format.html { render :layout => false }
    end

  end 
  
  def ofertas
    
    # TODO:
    # hacer un filtro de interesantes 
    # sacar tambien las de otros bazares
    # quitar la que ya tenemos como favoritas
    
    if params[:tipo] == "O"
      @ofertasrecomendadas = Bazarcms::Oferta.where("tipo = 'O' ").order("fecha_hasta desc").limit(18)
    else 
      @ofertasrecomendadas = Bazarcms::Oferta.where("tipo = 'D' ").order("fecha_hasta desc").limit(18)
    end 
    
    @totalempresas = Bazarcms::Empresa.count_by_sql("select count(*) from empresas")
    @totalofertas = Bazarcms::Oferta.count_by_sql("SELECT count(*) FROM ofertas where tipo = 'O' ") 
    @totaldemandas = Bazarcms::Oferta.count_by_sql("SELECT count(*) FROM ofertas where tipo = 'D' ")
    
    
  end
  
  def fichaoferta
    
    
    @fav = Bazarcms::Ofertasfavorito.find_by_user_id_and_bazar_id_and_oferta_id(current_user.id, params[:bazar], params[:id])

    if params[:bazar].to_i == BZ_param("BazarId").to_i
      @oferta = Bazarcms::Oferta.find_by_id(params[:id])
      if !@oferta.clicks.nil?
        @oferta.clicks += 1 
      else 
        @oferta.clicks = 1 
      end 
      @oferta.save 
       
      @empresa = Bazarcms::Empresa.find_by_id(@oferta.empresa_id)
      @imagenes = Bazarcms::Ofertasimagen.where("oferta_id = ?", params[:id])
      
      render :layout => false 
      
    else 
      # TODO: cachearlo para que vaya más rápido
      
      res = dohttpget(params[:bazar], "/home/fichaoferta/#{params[:bazar]}/#{params[:id]}")
      
      if (res == "404")
        res = dohttpget(params[:bazar], "/bazarcms/ofertas/#{params[:id]}?bazar_id=#{params[:bazar]}&display=inside")        
      end 
      
      render :text => res, :layout => false 
      
    end 
    
  end
  
  def busquedaoferta
    
    # TODO: controlar el tipo (O/D) que vamos a enviar como parametro
    params[:q] = '*' if (params[:q] == '') 
    params[:tipo] = 'O' if params[:tipo].nil?
    @ofertas, @ofertasresultados = Bazarcms::Oferta.busca(:tipo => params[:tipo], :q => params[:q], 
                                                          :user => current_user.id, :bazar => BZ_param("BazarId").to_i)
    
  end
  
  def ofertadatosgenerales
    
    if ( params[:bazar].to_i == BZ_param("BazarId").to_i )
      @oferta = Bazarcms::Oferta.find_by_bazar_id_and_id(params[:bazar], params[:id])
      if (@oferta.empresa_id != current_user.id)
        render :layout => false, :text => "No puede editar esta oferta. No es el dueño."       
      else
        render :layout => false
      end
    else
      render :layout => false, :text => "No puede editar una oferta de otro bazar #{params[:bazar].to_i} #{BZ_param("BazarId")}"      
    end 
    
  end 
  
  def actofertadatosgenerales
    
    # TODO hay que controlar que solo el usuario puede cambiarlo o tiene permisos 
    # admin/dinamizador 
  
    @oferta = Bazarcms::Oferta.find_by_id(params[:id])
    
    
    if @oferta.update_attributes(params[:bazarcms_oferta])
       redirect_to("/home/fichaoferta/#{params[:bazar]}/#{params[:id]}/") 
       # render :text => "OK", :layout => false
     else
       render :action => "ofertadatosgenerales", :layout => false 
     end
    
  end
  
  
  def empresas

    # TODO:
    # hacer un filtro de interesantes 
    # sacar tambien las de otros bazares
    # quitar la que ya tenemos como favoritas
    
    @empresasrecomendadas = Bazarcms::Empresa.where("nombre not like 'Escriba su%' ").order("updated_at desc").limit(18)
      
    @totalempresas = Bazarcms::Empresa.count_by_sql("select count(*) from empresas")

    # @totalofertas = Bazarcms::Oferta.count_by_sql("SELECT count(*) FROM ofertas where tipo = 'O' ") 
    # @totaldemandas = Bazarcms::Oferta.count_by_sql("SELECT count(*) FROM ofertas where tipo = 'D' ")
    
  end

  def fichaempresa
    
    # if local we get the info from database 
    # if not, we make a remote get 
    
    @fav = Favorito.find_by_user_id_and_bazar_id_and_empresa_id(current_user.id, params[:bazar].to_i, params[:id].to_i)
    
    
    if params[:bazar].to_i == BZ_param("BazarId").to_i
      @empresa = Bazarcms::Empresa.find_by_id(params[:id])
      if !@empresa.total_mostradas.nil?
        @empresa.total_mostradas += 1 
      else 
        @empresa.total_mostradas = 1 
      end 
      
      if @empresa.ambito.nil?
        @empresa.ambito = "2"
      end 
      
      @empresa.save 
    
      @ofertas = Bazarcms::Oferta.where("tipo = 'O' and empresa_id = ?", params[:id]).order("fecha desc")
      @demandas = Bazarcms::Oferta.where("tipo = 'D' and empresa_id = ?", params[:id]).order("fecha desc")        
      @imagenes = Bazarcms::Empresasimagen.where("empresa_id = ?", params[:id])
      @empresasdatos = Bazarcms::Empresasdato.where("empresa_id = ?", params[:id]).order("periodo desc").limit(1)
      
      if @empresadatos.nil? 
        @empresasdatos = Bazarcms::Empresasdato.new
        @empresasdatos.empresa_id = params[:id] 
        @empresasdatos.periodo = DateTime.now.year
        @empresasdatos.periodo = 0
        @empresasdatos.empleados = 0
        @empresasdatos.ventas = 0
        @empresasdatos.compras = 0
        @empresasdatos.resultados = 0
        @empresasdatos.save
      end 
      
      
      render
      
    else 
      # TODO: cachearlo para que vaya más rápido
      
      res = dohttpget(params[:bazar], "/home/fichaempresa/#{params[:bazar]}/#{params[:id]}")
      
      if (res == "404")
        res = dohttpget(params[:bazar], "/bazarcms/empresas/#{params[:id]}?bazar_id=#{params[:bazar]}&display=inside")        
      end 
      
      render :text => res, :layout => false 
      
    end 
    
  end

  def busquedaempresa
    
    # TODO: controlar el tipo (O/D) que vamos a enviar como parametro
    params[:q] = '*' if (params[:q] == '') 
    params[:tipo] = 'O' if params[:tipo].nil?
    @empresas, @empresasresultados = Bazarcms::Empresa.busca(:tipo => params[:tipo], :q => params[:q], 
                                                          :user => current_user.id, :bazar => BZ_param("BazarId").to_i)
    
  end

  def empresadatosgenerales
    
    # TODO hay que controlar que solo el usuario puede cambiarlo o tiene permisos 
    # admin/dinamizador 
    if ( params[:id].to_i == current_user.id )
      @empresa = Bazarcms::Empresa.find_by_id(params[:id])
    else
      @empresa = Bazarcms::Empresa.find_by_id(current_user.id)      
    end 
    
    render :layout => false
  end

  def actempresadatosgenerales
    
    # TODO hay que controlar que solo el usuario puede cambiarlo o tiene permisos 
    # admin/dinamizador 

    if ( params[:id].to_i == current_user.id )
      @empresa = Bazarcms::Empresa.find_by_id(params[:id])
    else
      @empresa = Bazarcms::Empresa.find_by_id(current_user.id)      
    end 
    
    if @empresa.update_attributes(params[:bazarcms_empresa])
       #redirect_to("/home/fichaempresa/#{params[:id]}/#{params[:bazar]}/") 
       render :text => "OK", :layout => false
     else
       render :action => "empresadatosgenerales", :layout => false 
     end
    
    
  end

  def favoritos
    
    @empresasfav = []
    favoritos = Favorito.where("user_id = ?", current_user.id).order("fecha desc")

    for fav in favoritos
      
      if fav.bazar_id == BZ_param("BazarId").to_i  
        
        empre = Bazarcms::Empresa.find_by_id(fav.empresa_id)
        if (!empre.nil?)
          f = empre.attributes
          f['bazar_id'] = fav.bazar_id
          @empresasfav << f
        end 
        # logger.debug "empresa local", fav.to_json.inspect 
      else 
        f = datos_empresa_remota(fav.bazar_id, fav.empresa_id)
        if !f.nil?
          f['bazar_id'] = fav.bazar_id 
          if f['estado'] == "OK"
            @empresasfav << f
          end
        end
      end 
    end 

    @ofertasfav = []
    @demandasfav = []
    
    favoritos = Bazarcms::Ofertasfavorito.where("user_id = ?", current_user.id).order("fecha desc")

    for fav in favoritos
      
      if fav.bazar_id == BZ_param("BazarId").to_i
        
        oferta = Bazarcms::Oferta.find_by_id(fav.oferta_id)
        if (!oferta.nil?)
          f = oferta.attributes
          f['bazar_id'] = BZ_param("BazarId")
          if oferta.tipo == "O"
            @ofertasfav << f
          else 
            @demandasfav << f
          end 
        end 
        logger.debug "oferta local ----> "+f.inspect 
      else 
        f = datos_oferta_remota(fav.bazar_id, fav.oferta_id)
        if !f.nil? 
          if f['estado'] == "OK"
            f['bazar_id'] = fav.bazar_id
            if f['tipo'] == "O"
              @ofertasfav << f
            else 
              @demandasfav << f            
            end
          else 
            logger.debug "Error: No se ha podido leer la oferta #{fav.oferta_id} del bazar #{fav.bazar_id}: -> #{f.inspect}"
          end
        else 
          logger.debug "Error: No se ha podido leer la oferta #{fav.oferta_id} del bazar #{fav.bazar_id} respuesta nula"          
        end 
      end 
    end 


    
#    traza = ""
#    @ofertasfav.each {|f| traza += "--->"+"<br/>"+f.inspect+"<br/>" }
#    render :text => traza

  end
  
  def delfav

    fav = Favorito.find_by_user_id_and_bazar_id_and_empresa_id(current_user.id, params[:bazar].to_i, params[:id].to_i)
    if (!fav.nil?)
      logger.debug "borro", fav.inspect
      fav.delete
      render :layout => false
    else 
      logger.debug "No puedo borrar: "+current_user.id.to_s+" "+params[:bazar]+" "+params[:id]
      render :text => "Error"
    end 
    
  end
  
  def addfav

    fav = Favorito.find_by_user_id_and_bazar_id_and_empresa_id(current_user.id, params[:bazar].to_i, params[:id].to_i)
    
    if ( !fav.nil?)
      logger.debug "Ya estaba como favorito"
    else 
      fav = Favorito.new
      
      fav.fecha = DateTime.now 
      fav.user_id = current_user.id
      fav.bazar_id = params[:bazar]
      fav.empresa_id = params[:id]
      
      fav.save
    end 
    
    render :layout => false
  end

  def delofefav

    fav = Bazarcms::Ofertasfavorito.find_by_user_id_and_bazar_id_and_oferta_id(current_user.id, params[:bazar].to_i, params[:id].to_i)
    if (!fav.nil?)
      logger.debug "borro", fav.inspect
      fav.delete
      render :layout => false
    else 
      logger.debug "No puedo borrar: "+current_user.id.to_s+" "+params[:bazar]+" "+params[:id]
      render :text => "Error"
    end 
    
  end
  
  def addofefav

    fav = Bazarcms::Ofertasfavorito.find_by_user_id_and_bazar_id_and_oferta_id(current_user.id, params[:bazar].to_i, params[:id].to_i)
    
    if ( !fav.nil?)
      logger.debug "Ya estaba como favorito"
    else 
      fav = Bazarcms::Ofertasfavorito.new
      
      fav.fecha = DateTime.now 
      fav.user_id = current_user.id
      fav.bazar_id = params[:bazar]
      fav.oferta_id = params[:id]
      fav.save
      
    end 
    
    render :layout => false
  end

  def crearimagenempresa
    
    @img = Bazarcms::Empresasimagen.create( params[:empresasimagen])
    @img.empresa_id = current_user.id 
    @img.save
    
    redirect_to "/home/fichaempresa/#{BZ_param('BazarId')}/#{current_user.id}/?go=imagenes"
    
  end 
  
  def delempresaimagen

    if (params[:empresa].to_i == current_user.id)
      @img = Bazarcms::Empresasimagen.find_by_id_and_empresa_id(params[:id], params[:empresa])
      if  @img.nil? 
        redirect_to "/home/fichaempresa/#{BZ_param('BazarId')}/#{current_user.id}/?go=imagenes"
      else 
        @img.delete 
        render :text => "OK"
      end 
    else 
      render :text => "No se puede borrar esta foto"
    end 
    
  end 

  def crearimagenoferta
    
    if ( params[:empresa].to_i == current_user.id )
      @img = Bazarcms::Ofertasimagen.create(params[:ofertasimagen])
      @img.oferta_id = params[:id] 
      @img.save
    end 
    redirect_to "/home/fichaoferta/#{BZ_param('BazarId')}/#{params[:id]}/?go=imagenes"
    
  end 
  
  def delofertaimagen

    @oferta = Bazarcms::Oferta.find_by_id(params[:oferta])
    
    if @oferta.nil?
      redirect_to "/home"
    end
    
    if (@oferta.empresa_id == current_user.id)
      @img = Bazarcms::Ofertasimagen.find_by_id_and_oferta_id(params[:id], params[:oferta])
      if  @img.nil? 
        redirect_to "/home/fichaoferta/#{BZ_param('BazarId')}/#{params[:id]}/?go=imagenes"
      else 
        @img.delete 
        render :text => "OK"
      end 
    else 
      render :text => "No se puede borrar esta foto"
    end 
    
  end
  
  def test
    
  end

end
