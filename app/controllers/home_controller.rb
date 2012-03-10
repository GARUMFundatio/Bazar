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
      if !@oferta.nil?
        if !@oferta.clicks.nil?
          @oferta.clicks += 1 
        else 
          @oferta.clicks = 1 
        end 
        if !@oferta.vistas.nil?
          @oferta.vistas += 1 
        else 
          @oferta.vistas = 1 
        end 
        @oferta.save 
      end 
      
       
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
  
  def editaroferta
    
    if current_user.id == params[:id].to_i
      @oferta = Bazarcms::Oferta.find_by_id(params[:oferta])
      @empresa = Bazarcms::Empresa.find_by_id(@oferta.empresa_id)
      @imagenes = Bazarcms::Ofertasimagen.where("oferta_id = ?", params[:oferta])
      
      render :layout => false 
      
    else 
      render :text => "No se puede editar esta oferta", :layout => false       
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

    if !params[:bazarcms_oferta].nil?      
      if !params[:bazarcms_oferta][:fecha_hasta].nil?  
        fe = params[:bazarcms_oferta][:fecha_hasta].split('/')
        params[:bazarcms_oferta][:fecha_hasta] = fe[2]+'-'+fe[1]+'-'+fe[0]
      end 

      if @oferta.update_attributes(params[:bazarcms_oferta])
         redirect_to("/home/fichaoferta/#{params[:bazar]}/#{params[:id]}/") 
       else
         render :action => "ofertadatosgenerales", :layout => false 
       end
    else 
      if !params[:tags].nil?
        @oferta.palabrasclave_list = params[:tags]
        @oferta.save
        redirect_to("/home/fichaoferta/#{params[:bazar]}/#{params[:id]}/")         
      end 
    end 
    
    
  end
  
  def crearoferta
    
    nueva = false 
    if (params[:tipo] == "O")
      @oferta = Bazarcms::Oferta.find_by_tipo_and_empresa_id("EO", params[:id])
    else 
      @oferta = Bazarcms::Oferta.find_by_tipo_and_empresa_id("ED", params[:id])
    end

    if (@oferta.nil?)
      @oferta = Bazarcms::Oferta.new
      nueva = true
    end 
    
    if (params[:bazar].to_i != BZ_param("BazarId").to_i)
      @oferta.bazar_id = BZ_param("BazarId")
    else 
      @oferta.bazar_id = params[:bazar]
    end 
    
    if (params[:id].to_i != current_user.id)
      @oferta.empresa_id = current_user.id
    else 
      @oferta.empresa_id = params[:id]
    end 
    
    if (params[:tipo] == "O")
      @oferta.tipo = "EO"
    else 
      @oferta.tipo = "ED"      
    end
    
    if (nueva) 
      @oferta.titulo = "nil"
    end
    
    @oferta.save 
    
    render :layout => false 
    
  end
  
  def imagenesoferta 
  
    @oferta = Bazarcms::Oferta.find_by_id(params[:oferta])
    @imagenes =  Bazarcms::Ofertasimagen.where("oferta_id = ?", params[:oferta])
    @mostrar = nil
    @owner = true 
    render :layout => false

  end 
  
  def subirimagenoferta
    logger.debug "datos recibidos:"+params.inspect
    @img = Bazarcms::Ofertasimagen.new
    @img.imagen = params[:imagen]
    @img.oferta_id = params[:oferta]
    @img.save
    render :text => "imagen subida "+ params.inspect
  end
  
  def cancelaroferta

    @oferta = Bazarcms::Oferta.find_by_id_and_empresa_id(params[:oferta], current_user.id)
    
    if !@oferta.nil?
      @imagenes = Bazarcms::Ofertasimagen.where("oferta_id = ?", params[:oferta])
      for img in @imagenes 
        img.delete
      end
      @oferta.delete
    end 
    
    render :text => "OK"
     
  end
  
  def publicaroferta

    @oferta = Bazarcms::Oferta.find_by_id_and_empresa_id(params[:oferta], current_user.id)
    
    tmp = params[:bazarcms_oferta][:fecha_hasta].split("\/-")
    logger.debug "fecha hasta "+params[:bazarcms_oferta][:fecha_hasta]+" "+tmp.inspect 
    params[:bazarcms_oferta][:fecha_hasta] = "#{tmp[2]}-#{tmp[1]}-#{tmp[0]}"

    @oferta.update_attributes(params[:bazarcms_oferta])
    @oferta.palabrasclave_list = params[:tags]
    if @oferta.tipo == "EO"
      @oferta.tipo = "O"
    else 
      @oferta.tipo = "D"
    end
    @oferta.fecha = DateTime.now 
    @oferta.vistas = 0 
    @oferta.clicks = 0
    @oferta.save
    
    logger.debug params.inspect 
    
    if @oferta.ambito == "1"
      paises = ""
      ubis = Bazarcms::Empresa.find_by_id(current_user.id).ubicaciones
      for ubi in ubis 
        if !paises.include? ubi.ciudad.pais_codigo 
          paises += ubi.ciudad.pais_codigo+"+"
        end 
      end
    else 
      paises = "all"
    end 
    
    data = Bazarcms::Empresa.empresasestimadas(@oferta.ambito, params[:tags], paises, "data")
    logger.debug "seleccionadas: "+data.inspect
    
    micluster = BZ_param("BazarId").to_i 
    total = 0
    for empre in JSON.parse(data)
      logger.debug empre.inspect+" cluster "+empre[0].to_s+" empresa "+empre[1].to_s
      total += 1 
      
      if empre[0] != micluster 
        emp = datos_empresa_remota(empre[0], empre[1])
        logger.debug emp.inspect 
      else 
        emp = Bazarcms::Empresa.find(empre[1])
        logger.debug emp.inspect         
      end 
      
      if (empre[0] == micluster)

        logger.debug "Es un mensaje con una empresa local!!!"

        emp = Bazarcms::Empresa.find_by_id(current_user.id)
        nombre = emp.nombre

        user = User.find_by_id(empre[1])
        if (!user.nil?)
          para = user.email
        else 
          logger.debug "Error: no tiene correo o no se localiza la empresa <-----------"
          para = "erroresencorreo@bazarum.com"
        end 
        
        if @oferta.tipo == "O"
          tmp = "oferta"
        else 
          tmp = "demanda"
        end 
        
        texto = "
        <html><body style='background-color: #fff;color: #666; font-family: arial;font-size: 15px;font-weight: bold;'>
        La empresa: <b>#{nombre}</b> le ha enviado una #{tmp}.
        </br>
        Le sugerimos:
        </br>
        * <a href='#{Cluster.find_by_id(micluster).url}/home/fichaempresa/#{micluster}/#{current_user.id}?go=oferta&oferta=#{@oferta.id}'>Ver la #{tmp}: #{@oferta.titulo}</a>
        </br>
        * <a href='#{Cluster.find_by_id(micluster).url}/home/fichaempresa/#{micluster}/#{current_user.id}'>Ver la ficha de empresa de #{nombre}</a>
        </br>
        </body></html>
        "

        BazarMailer.enviamensaje("#{BZ_param('Titular')} <noreplay@garumfundatio.org>", 
                                    para, 
                                    "#{BZ_param('Titular')}: #{tmp} de la empresa #{nombre}", 
                                    texto).deliver      

      else  

#      emp = Bazarcms::Empresa.find_by_id(current_user.id)
#      nombre = emp.nombre
#
#      user = User.find_by_id(current_user.id)
#      para = user.email
#
#      @mensaje2 = Mensaje.new()
#      @mensaje2.fecha = DateTime.now
#
#      @mensaje2.bazar_origen = BZ_param('BazarId')
#      @mensaje2.de = user.id
#      @mensaje2.de_nombre = emp.nombre
#      @mensaje2.de_email = user.email
#
#
#      @mensaje2.bazar_destino = params[:bazar]
#      @mensaje2.para = params[:empresa]
#
#      # Estos datos los coge en remoto
#
#      @mensaje2.para_nombre = "" 
#      @mensaje2.para_email = "" 
#
#
#      @mensaje2.tipo = "M"
#      @mensaje2.leido = nil 
#      @mensaje2.borrado = nil
#
#      @mensaje2.asunto = "#{BZ_param('Titular')}: La empresa #{nombre} le ha añadido a sus favoritos."
#      @mensaje2.texto = "
#
#      <br/>
#      La empresa: #{nombre} le ha añadido a sus favoritos.
#      </br>
#      Le sugerimos: 
#      </br>
#      * <a href='#{Cluster.find_by_id(params[:bazar]).url}/bazarcms/empresas/#{current_user.id}?bazar_id=#{BZ_param('BazarId')}'>Ver la ficha de empresa de #{nombre}</a>
#      </br>
#      * <a href='#{Cluster.find_by_id(params[:bazar]).url}/bazarcms/ficharating/#{current_user.id}?bazar_id=#{BZ_param('BazarId')}'>Ver el rating de #{nombre}</a>
#      </br>
#      * <a href='#{Cluster.find_by_id(params[:bazar]).url}/favorito/addfav?bazar=#{BZ_param('BazarId')}&empresa=#{current_user.id}&nombre_empresa=#{nombre.gsub(' ','_')}&pre=auto'>Añadir #{nombre} a sus favoritos</a>
#
#      "
#
#
#      logger.debug "Enviando el mensaje a #{@mensaje2.bazar_destino}"
#
#      dohttppost(@mensaje2.bazar_destino, "/mensajeremoto", @mensaje2.to_json)
#
#      @mensaje2.destroy
#
      end
      
      
      
    end
    
    @oferta.total_empresas = total 
    @oferta.contactos = 0
    @oferta.fav_empresa = 0
    @oferta.fav_oferta = 0
     
    render :layout => false 
    # redirect_to("/home/fichaempresa/#{BZ_param("BazarId")}/#{current_user.id}/")

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

      if @empresa.sector.nil?
        @empresa.sector = "01"
      else 
        if @empresa.sector.length <= 1 
          @empresa.sector = "01"
        end
      end 

      @empresa.save 
    
      @ofertas = Bazarcms::Oferta.where("tipo = 'O' and empresa_id = ?", params[:id]).order("fecha desc")
      @demandas = Bazarcms::Oferta.where("tipo = 'D' and empresa_id = ?", params[:id]).order("fecha desc")        
      @imagenes = Bazarcms::Empresasimagen.where("empresa_id = ?", params[:id])
      @ed = Bazarcms::Empresasdato.where("empresa_id = ?", params[:id]).order("periodo desc").limit(1)
      
      if @ed.nil? 
        @empresasdatos = Bazarcms::Empresasdato.new
        @empresasdatos.empresa_id = params[:id] 
        @empresasdatos.periodo = DateTime.now.year
        @empresasdatos.empleados = 0
        @empresasdatos.ventas = 0
        @empresasdatos.compras = 0
        @empresasdatos.resultados = 0
        @empresasdatos.save
      else 
        @empresasdatos = @ed[0]
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

  def empresadatosgenerales2
    
    # TODO hay que controlar que solo el usuario puede cambiarlo o tiene permisos 
    # admin/dinamizador 
    if ( params[:id].to_i == current_user.id )
      @empresa = Bazarcms::Empresa.find_by_id(params[:id])
    else
      @empresa = Bazarcms::Empresa.find_by_id(current_user.id)      
    end 

    @ed = Bazarcms::Empresasdato.where("empresa_id = ?", params[:id]).order("periodo desc").limit(1)
    
    logger.debug "empresasdatos -> "+@empresasdatos.inspect
    if @ed.nil? 
      logger.debug "No hay datos para esta empresa"
      @empresasdatos = Bazarcms::Empresasdato.new
      @empresasdatos.empresa_id = params[:id] 
      @empresasdatos.periodo = DateTime.now.year
      @empresasdatos.empleados = 0
      @empresasdatos.ventas = 0
      @empresasdatos.compras = 0
      @empresasdatos.resultados = 0
      @empresasdatos.save
    else 
      
      if @ed[0].periodo != DateTime.now.year
        logger.debug "No hay datos para este año!!!! los creo con el último año"
        @empresasdatos = Bazarcms::Empresasdato.new
        @empresasdatos.empresa_id = params[:id] 
        @empresasdatos.periodo = DateTime.now.year
        @empresasdatos.empleados = @ed[0].empleados
        @empresasdatos.ventas = @ed[0].ventas
        @empresasdatos.compras = @ed[0].compras
        @empresasdatos.resultados = @ed[0].resultados
        @empresasdatos.save
      else
        @empresasdatos = @ed[0]
      end      
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

    if ( !params[:bazarcms_empresasdato].nil? )
      if ( params[:id].to_i == current_user.id )
        @empresasdatos = Bazarcms::Empresasdato.find_by_empresa_id_and_periodo(params[:id], DateTime.now.year)
      else
        @empresasdatos = Bazarcms::Empresasdato.find_by_empresa_id_and_periodo(current_user.id, DateTime.now.year)
      end 

      if !@empresasdatos.nil? 
        @empresasdatos.update_attributes(params[:bazarcms_empresasdato])
      else 
        logger.debug "No he encontrado datos para estos parametros --->"+params.inspect
      end 
    
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
  
  def empresasestimadas
  
    total = "todas"
    paises = ""
    if !params[:tipo].nil?
      tipo = params[:tipo]
    else 
      tipo = "total"
    end 
    
    if !params[:pals].nil?
      pals = params[:pals]
    else 
      pals = ""
    end 
    
    if !params[:ambito].nil?
      ambito = params[:ambito]
      if ambito == "0" || ambito == "1"
        paises = params[:paises]
      end 
    else 
      ambito = nil
      paises = nil
    end 
    
    logger.debug "viene ----> "+params.inspect+" "+ambito.inspect+" "+pals.inspect
    @total, @empresas = Bazarcms::Empresa.empresasestimadas(ambito, pals, paises, tipo)

    if (tipo == "total")
      render :text => @total
    else
      render :text => @total
    end 


  end
  
  def editarcorreo 


    @mensaje = Mensaje.new 
    
    @mensaje.fecha = DateTime.now 
    @mensaje.tipo = "M"
    @mensaje.borrado = "N"
    @mensaje.leido = "N"
    @mensaje.de = current_user.id
    @mensaje.para = params[:id]
    @mensaje.texto = ""
    @mensaje.asunto = ""
    @mensaje.bazar_origen = BZ_param("BazarId")
    @mensaje.bazar_destino = params[:bazar]

    @mensaje.de_email = current_user.email
    
    nombre = Bazarcms::Empresa.find(current_user.id).nombre
    if nombre.nil? 
      nombre = current_user.email
    end 
    
    @mensaje.de_nombre = nombre
     
    @mensaje.para_email = ""
    @mensaje.para_nombre = ""
    
    if params[:bazar].to_i == BZ_param("BazarId").to_i
      @empresa = Bazarcms::Empresa.find_by_id(params[:id])
      if @empresa.total_mostradas.nil?
        @empresa.total_mostradas = 1 
      end 
      
      if @empresa.ambito.nil?
        @empresa.ambito = "2"
      end 

      if @empresa.sector.nil?
        @empresa.sector = "01"
      else 
        if @empresa.sector.length <= 1 
          @empresa.sector = "01"
        end
      end 

      @empresa.save 
    
      @mensaje.para_email = User.find(params[:id]).email
      @mensaje.para_nombre = @empresa.nombre
  
      
    else 
      
      res = datos_empresa_remota(params[:bazar], params[:id])
      logger.debug "Los datos que llegaron fueron: "+res.inspect
      
      if !res.nil? 
        @mensaje.para_email = res['email']
        @mensaje.para_nombre = res['nombre']
      else 
        logger.debug "ERROR: No he podido conseguir los datos remotos de la empresa #{params[:id]} del bazar #{params[:bazar]}"
       end 
    end    
    
    @mensaje.save
    
    render :layout => false 
    
  end
  
  def enviarcorreo 
        
    logger.debug("params          : "+params.inspect)
    logger.debug("params - mensaje: "+params[:mensaje].inspect)
    
   
    @mensaje = Mensaje.find_by_id(params[:id])
    @mensaje.update_attributes(params[:mensaje])
    @mensaje.save 
    
    micluster = BZ_param("BazarId")
    
    texto = "
    <html><body style='background-color: #fff;color: #666; font-family: arial;font-size: 15px;font-weight: bold;'>
    
    #{@mensaje.texto}
    
    </br>
    * <a href='#{Cluster.find_by_id(micluster).url}/home/fichaempresa/#{micluster}/#{current_user.id}'>Ver la ficha de empresa de #{@mensaje.de_nombre}</a>
    </br>
    </body></html>
    "

    BazarMailer.enviamensaje("#{@mensaje.de_nombre} <#{@mensaje.de_email}>", 
                                @mensaje.para_email, 
                                "#{@mensaje.asunto}", 
                                texto).deliver
    
    render :layout  => false 
    
    #redirect_to "/home/fichaempresa/#{@mensaje.bazar_destino}/#{@mensaje.para}"

  end
  
  def rating 
    
    # validamos que no nos estemos votando a nosotros mismos 
    
    if (params[:bazar].to_i == BZ_param("BazarId").to_i && params[:id].to_i == current_user.id )
      logger.debug "Good try"
    else 
      # comprobamos si ha votado más de una vez
      
      rating = Bazarcms::Rating.where("( ori_bazar_id = ? and ori_empresa_id = ? and des_bazar_id = ? and des_empresa_id = ? )", 
                                      BZ_param("BazarId").to_i, current_user.id, params[:bazar].to_i, params[:id].to_i)
      if !rating.nil? 
        logger.debug "Ya existía un rating para esta empresa"
      else 
        logger.debug "rating: el valor que viene para votar es: #{params[:valor]}"
        
        if params[:valor].to_i <= 0 || params[:valor].to_i > 5 
          valor = 2
        else 
          valor = params[:valor]
        end 
        
        @rating = Bazarcms::Rating.new
        
        @rating.ori_fecha = DateTime.now      
        @rating.role = "C"
        @rating.token = rand(99999)+1
          
        @rating.ori_cliente_plazos = 0
        @rating.ori_cliente_comunicacion = 0
           
        @rating.ori_proveedor_expectativas = valor
        @rating.ori_proveedor_plazos = valor
        @rating.ori_proveedor_comunicacion = valor
        
        @rating.save 
      
        @rating.iden = "#{@rating.id}-#{@rating.ori_bazar_id}-#{@rating.ori_empresa_id}"
        @rating.save 
        
        if (@rating.des_bazar_id == BZ_param('BazarId').to_i)  
          @rating.calculo(@rating.des_bazar_id, @rating.des_empresa_id)
        else
          # lo enviamos a destino
          logger.debug "Enviando rating a #{@rating.des_bazar_id}"
          dohttppost(@rating.des_bazar_id, "/bazarcms/recrating", @rating.to_json)
        end 
        
        # avisamos con un correo a la empresa destinataria

        if (@rating.des_bazar_id.to_i == BZ_param("BazarId").to_i)

          logger.debug "Es un mensaje con una empresa local!!!"

          emp = Bazarcms::Empresa.find_by_id(current_user.id)
          nombre = emp.nombre
          user = User.find_by_id(@rating.des_empresa_id)
          para = user.email
          texto = "
          <html><body style='background-color: #fff;color: #666; font-family: arial;font-size: 15px;font-weight: bold;'>
          La empresa: #{nombre} ha evaluado su empresa.
          </br>
          Le sugerimos: 
          </br>
          * <a href='#{Cluster.find_by_id(BZ_param('BazarId')).url}/home/fichaempresa/#{BZ_param('BazarId')}/#{@rating.des_empresa_id}'>Evalue a la empresa #{nombre}.</a> 
          Esta acción le aparecerá en tareas pendientes. Recuerde que hasta que no evalue a la otra empresa no afectará al rating de las dos empresas.
          </br>
          * <a href='#{Cluster.find_by_id(BZ_param('BazarId')).url}/home/fichaempresa/#{BZ_param('BazarId')}/#{current_user.id}'>Ver la ficha de empresa de #{nombre}</a>
          </br>
          </body></html>
          "
          BazarMailer.enviamensaje("#{BZ_param('Titular')} <noreplay@garumfundatio.org>", 
                                      para, 
                                      "#{BZ_param('Titular')}: La empresa #{nombre} ha evaluado su empresa.", 
                                      texto).deliver      

        else  

          emp = Bazarcms::Empresa.find_by_id(current_user.id)
          nombre = emp.nombre

          user = User.find_by_id(current_user.id)
          para = user.email

          @mensaje2 = Mensaje.new()
          @mensaje2.fecha = DateTime.now

          @mensaje2.bazar_origen = BZ_param('BazarId')
          @mensaje2.de = user.id
          @mensaje2.de_nombre = emp.nombre
          @mensaje2.de_email = user.email


          @mensaje2.bazar_destino = @rating.des_bazar_id
          @mensaje2.para = @rating.des_empresa_id

          # Estos datos los coge en remoto

          @mensaje2.para_nombre = "" 
          @mensaje2.para_email = "" 


          @mensaje2.tipo = "M"
          @mensaje2.leido = nil 
          @mensaje2.borrado = nil

          @mensaje2.asunto = "#{BZ_param('Titular')}: La empresa #{nombre} ha evaluado su empresa."
          @mensaje2.texto = "
          <html><body style='background-color: #fff;color: #666; font-family: arial;font-size: 15px;font-weight: bold;'>
          <br/>
          La empresa: #{nombre} ha evaluado su empresa.
          </br>
          Le sugerimos: 
          </br>
          * <a href='#{Cluster.find_by_id(@rating.des_bazar_id).url}/home/fichaempresa/#{BZ_param('BazarId')}/#{current_user.id}'>Evalue a la empresa #{nombre}.</a> 
          Esta acción le aparecerá en tareas pendientes. Recuerde que hasta que no evalue a la otra empresa no afectará al rating de las dos empresas.
          </br>
          * <a href='#{Cluster.find_by_id(@rating.des_bazar_id).url}/bazarcms/empresas/#{current_user.id}?bazar_id=#{BZ_param('BazarId')}'>Ver la ficha de empresa de #{nombre}</a>
          </br>
          </body></html>
          "

          logger.debug "Enviando el mensaje a #{@mensaje2.bazar_destino}"

          dohttppost(@mensaje2.bazar_destino, "/mensajeremoto", @mensaje2.to_json)

          @mensaje2.destroy

        end
        
      end 
      
    end 

    redirect_to "/home/fichaempresa/#{params[:bazar]}/#{params[:id]}"
    
  end
    
  def test
    
  end

end
