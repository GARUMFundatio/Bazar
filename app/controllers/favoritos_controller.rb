class FavoritosController < ApplicationController
  # GET /favoritos
  # GET /favoritos.xml
  
  before_filter :require_user, :only => [:addfav, :delfav]
  
  layout 'bazar'
  def index
    
    @favoritos = Favorito.where("user_id = ?", current_user.id).order("fecha desc").paginate(:per_page => 30, :page => params[:page])

    if request.xhr?
      render :partial => @favoritos
    end 
    
  end

  
  # GET /favoritos/1
  # GET /favoritos/1.xml
  def show
    @favorito = Favorito.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @favorito }
    end
  end

  # GET /favoritos/new
  # GET /favoritos/new.xml
  def new
    @favorito = Favorito.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @favorito }
    end
  end

  # GET /favoritos/1/edit
  def edit
    @favorito = Favorito.find(params[:id])
  end

  # POST /favoritos
  # POST /favoritos.xml
  def create
    @favorito = Favorito.new(params[:favorito])

    respond_to do |format|
      if @favorito.save
        format.html { redirect_to(@favorito, :notice => 'Favorito was successfully created.') }
        format.xml  { render :xml => @favorito, :status => :created, :location => @favorito }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @favorito.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /favoritos/1
  # PUT /favoritos/1.xml
  def update
    @favorito = Favorito.find(params[:id])

    respond_to do |format|
      if @favorito.update_attributes(params[:favorito])
        format.html { redirect_to(@favorito, :notice => 'Favorito was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @favorito.errors, :status => :unprocessable_entity }
      end
    end
  end

  def addfav
    @fav = Favorito.find_by_user_id_and_bazar_id_and_empresa_id(current_user.id, params[:bazar], params[:empresa])
    
    if @fav.nil? 
      @fav = Favorito.new
      @fav.fecha = DateTime.now 
      @fav.bazar_id = params[:bazar] 
      @fav.empresa_id = params[:empresa]
      @fav.nombre_empresa = params[:nombre_empresa].gsub('_',' ')
      @fav.user_id = current_user.id
      @fav.save 
    else 
      logger.debug "Ya estaba en favoritos!!! #{params.inspect}"
    end 

    # enviamos un correo a la empresa que ha sido añadida como favorita
    
    
    # de momento solo enviamos una notificación por correo normal
    # TODO: JT  revisar si deberíamos dejar también una notificación 
    # en el correo interno. 
      
      
    if (params[:bazar].to_i == BZ_param("BazarId").to_i)

      logger.debug "Es un mensaje con una empresa local!!!"

      emp = Bazarcms::Empresa.find_by_id(current_user.id)
      nombre = emp.nombre

      user = User.find_by_id(params[:empresa])
      
      para = user.email
      
      texto = "

      La empresa: #{nombre} le ha añadido a sus favoritos.
      </br>
      Le sugerimos: 
      </br>
      * <a href='#{Cluster.find_by_id(BZ_param('BazarId')).url}/bazarcms/empresas/#{current_user.id}?bazar_id=#{params[:bazar]}'>Ver la ficha de empresa de #{nombre}</a>
      </br>
      * <a href='#{Cluster.find_by_id(BZ_param('BazarId')).url}/bazarcms/ficharating/#{current_user.id}?bazar_id=#{params[:bazar]}'>Ver el rating de #{nombre}</a>
      </br>
      * <a href='#{Cluster.find_by_id(BZ_param('BazarId')).url}/favorito/addfav?bazar=#{params[:bazar]}&empresa=#{current_user.id}&nombre_empresa=#{nombre.gsub(' ','_')}&pre=auto'>Añadir #{nombre} a sus favoritos</a>

      "

      BazarMailer.enviamensaje("#{BZ_param('Titular')} <noreplay@garumfundatio.org>", 
                                  para, 
                                  "#{BZ_param('Titular')}: La empresa #{nombre} le ha añadido a sus favoritos.", 
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

      
      @mensaje2.bazar_destino = params[:bazar]
      @mensaje2.para = params[:empresa]
      
      # Estos datos los coge en remoto
      
      @mensaje2.para_nombre = "" 
      @mensaje2.para_email = "" 

      
      @mensaje2.tipo = "M"
      @mensaje2.leido = nil 
      @mensaje2.borrado = nil

      @mensaje2.asunto = "#{BZ_param('Titular')}: La empresa #{nombre} le ha añadido a sus favoritos."
      @mensaje2.texto = "

      <br/>
      La empresa: #{nombre} le ha añadido a sus favoritos.
      </br>
      Le sugerimos: 
      </br>
      * <a href='#{Cluster.find_by_id(params[:bazar]).url}/bazarcms/empresas/#{current_user.id}?bazar_id=#{BZ_param('BazarId')}'>Ver la ficha de empresa de #{nombre}</a>
      </br>
      * <a href='#{Cluster.find_by_id(params[:bazar]).url}/bazarcms/ficharating/#{current_user.id}?bazar_id=#{BZ_param('BazarId')}'>Ver el rating de #{nombre}</a>
      </br>
      * <a href='#{Cluster.find_by_id(params[:bazar]).url}/favorito/addfav?bazar=#{BZ_param('BazarId')}&empresa=#{current_user.id}&nombre_empresa=#{nombre.gsub(' ','_')}&pre=auto'>Añadir #{nombre} a sus favoritos</a>

      "


      logger.debug "Enviando el mensaje a #{@mensaje2.bazar_destino}"

      dohttppost(@mensaje2.bazar_destino, "/mensajeremoto", @mensaje2.to_json)

      @mensaje2.destroy
     
    end

    Actividad.graba("Ha añadido a favoritos la empresa: <a href='#{Cluster.find_by_id(BZ_param('BazarId')).url}/bazarcms/empresas/#{params[:empresa]}?bazar_id=#{params[:bazar]}'>#{params[:nombre_empresa].gsub('_',' ')}</a>.", "USER",  BZ_param("BazarId"), current_user.id, nombre)

    # forzamos que se actulicen los caches relacionados con favoritos. 
    
    
    expire_fragment "bazar_favoritos_dash_#{current_user.id}"
    expire_fragment "ofertasdash"
    expire_fragment "bazar_actividades_dashboard"
    
    @pre = params[:pre]
    
    if params[:pre] == "auto"
      render :action => "added"
    else 
      render :layout => false        
    end 
    
  end

  def delfav
    @fav = Favorito.find_by_user_id_and_bazar_id_and_empresa_id(current_user.id, params[:bazar], params[:empresa])

    if !@fav.nil? 
      @fav.destroy 
    else 
      logger.debug "No estaba en favoritos!!! #{params.inspect}"
    end 
    
    expire_fragment "bazar_favoritos_dash_#{current_user.id}"
    expire_fragment "ofertasdash"
    expire_fragment "bazar_actividades_dashboard"
    
    
    @pre = params[:pre]
    
    if !@fav.nil?    
      render :layout => false  
    else
      redirect_to("/favorito/addfav?bazar=#{params[:bazar]}&empresa=#{params[:empresa]}&nombre_empresa=#{params[:nombre_empresa]}&pre=#{params[:pre]}")
    end 
      
  end



  # DELETE /favoritos/1
  # DELETE /favoritos/1.xml
  def destroy
    @favorito = Favorito.find(params[:id])
    @favorito.destroy

    respond_to do |format|
      format.html { redirect_to(favoritos_url) }
      format.xml  { head :ok }
    end
  end
  
  # empresas que sigue un usuario 
  
  def added 
    
  end 
  
  def dashboard 
    
    @favoritos = Favorito.where("user_id = ?", current_user.id).order("fecha desc").limit(5)
    @total = Favorito.count_by_sql("select count(*) from favoritos where user_id = #{current_user.id} ;")

    respond_to do |format|
      format.html { render :layout => false }
    end
  end
  
end
