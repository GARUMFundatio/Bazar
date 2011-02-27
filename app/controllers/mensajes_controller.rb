class MensajesController < ApplicationController
  layout "bazar"
  
  skip_before_filter :verify_authenticity_token, :only => :mensajeremoto
  
  def index
    puts "-------> parametros: ("+params.inspect+")"
    if (!params[:tipo].nil?)
      if (params[:tipo] == 'N')
        puts "Buscando notificaciones"
        @mensajes = Mensaje.notificacionestotal(current_user.id).order('fecha desc').paginate(:page => params[:page], :per_page => 15)
      else 
        puts "Buscando Mensajes"
        @mensajes = Mensaje.mensajestotal(current_user.id).order('fecha desc').paginate(:page => params[:page], :per_page => 15)      
      end 
    else 
      puts "No esta definido tipo"
      @mensajes = Mensaje.where('para = ? and tipo = "N"',[current_user.id]).order('fecha desc').paginate(:page => params[:page], :per_page => 15)
    end 
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @mensajes }
    end

  end

  def editanotificacion
    
  end
  
  def leido 
    puts "leido #{params[:id]}"
    puts "Usuario actual #{current_user.id}"
    @mensaje = Mensaje.find(params[:id])
    if(@mensaje.para == current_user.id)
      @mensaje.leido = DateTime.now 
      @mensaje.save
    else 
      puts "Este mensaje #{@mensaje.para} No era del usuario #{current_user.id}"
    end 
  end 
  
  def show
    @mensaje = Mensaje.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @mensaje }
    end
  end

  def new
    @mensaje = Mensaje.new
    
    if (!params[:nombre].nil?)
      @nombre = params[:nombre]
    else 
      @nombre = ""
    end 
    
    @mensaje.de = current_user.id
    @mensaje.bazar_origen = BZ_param("BazarId")
    
    if (!params[:aquien].nil?)
      @mensaje.para = params[:aquien]
    else
      @mensaje.para = 0
    end
    
    if (!params[:bazar_destino].nil?)
      @mensaje.bazar_destino = params[:bazar_destino]
    else
      @mensaje.bazar_destino = BZ_param("BazarId")
    end
    
    if (!params[:tipo].nil?)
      @mensaje.tipo = params[:tipo]
    else
      @mensaje.tipo = 'M'
    end
    
    @mensaje.fecha = DateTime.now
    @mensaje.leido = nil 
    @mensaje.borrado = nil
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @mensaje }
    end
  end

  def notificacion 
    @mensaje = Mensaje.new
    @mensaje.de = current_user.id
    @mensaje.para = -1

    if (!params[:tipo].nil?)
      @mensaje.tipo = params[:tipo]
    else
      @mensaje.tipo = 'M'
    end
    
    @mensaje.fecha = DateTime.now
    @mensaje.leido = nil 
    @mensaje.borrado = nil
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @mensaje }
    end

  end
  
  def enviarnotificacion

    for user in User::all 
      @mensaje = Mensaje.new(params[:mensaje])
      @mensaje.para = user.id 
      @mensaje.save
      
      BazarMailer.enviamensaje(User.find(@mensaje.de).email, 
                                User.find(@mensaje.para).email, 
                                @mensaje.asunto, 
                                @mensaje.texto).deliver
      
    end 

    respond_to do |format|
      if @mensaje.tipo == 'M'
        format.html { redirect_to("/mensajes?tipo=M", :notice => 'Mensaje ha sido enviado.') }
      else
        format.html { redirect_to("/mensajes?tipo=N", :notice => 'Mensaje ha sido enviado.') }        
      end
      format.xml  { render :xml => @mensaje, :status => :created, :location => @mensaje }
    end
    
  end
  
  def edit
    @mensaje = Mensaje.find(params[:id])
    texto = "\n\n\n"

    @mensaje.texto.each_line do |l|
      texto += "> #{l}"
    end
    @mensaje.texto = texto
    
  end

  def create
    
    # solo grabamos el mensaje en local si el destinatario es local 
    # si no enviamos la petición al bazar de destino 
    
    @mensaje = Mensaje.new(params[:mensaje])

    respond_to do |format|

      # si el mensaje tiene un destinatario local   
      
      logger.debug "----------> (#{@mensaje.bazar_destino}) (#{BZ_param("BazarId")})"
      if (@mensaje.bazar_destino.to_i == BZ_param("BazarId").to_i)
        logger.debug "Es un mensaje con destino local!!!"
        
        if @mensaje.save
        
          BazarMailer.enviamensaje(User.find(@mensaje.de).email, 
                                    User.find(@mensaje.para).email, 
                                    @mensaje.asunto, 
                                    @mensaje.texto).deliver
          if @mensaje.tipo == 'M'
            format.html { redirect_to("/mensajes?tipo=M", :notice => 'Mensaje ha sido enviado.') }
          else
            format.html { redirect_to("/mensajes?tipo=N", :notice => 'Mensaje ha sido enviado.') }        
          end
          format.xml  { render :xml => @mensaje, :status => :created, :location => @mensaje }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @mensaje.errors, :status => :unprocessable_entity }
        end
      else 
        # enviamos el mensaje al bazar de destino
        logger.debug "Enviando el mensaje a #{@mensaje.bazar_destino}"
        
        dohttppost (@mensaje.bazar_destino, "/mensajeremoto", @mensaje.to_json)
        
        format.html { redirect_to("/home") }
        
      end
      
      
    end
  end

  # PUT /mensajes/1
  # PUT /mensajes/1.xml
  def update
    
    @mensaje = Mensaje.find(params[:id])
    @mensaje2 = Mensaje.new(params[:mensaje])
    @mensaje2.fecha = DateTime.now
    @mensaje2.de = @mensaje.para
    @mensaje2.para = @mensaje.de 
    @mensaje2.tipo = @mensaje.tipo
    @mensaje2.leido = nil 
    @mensaje2.borrado = nil
    
    respond_to do |format|
      if @mensaje2.save
        BazarMailer.enviamensaje(User.find(@mensaje2.de).email, 
                                  User.find(@mensaje2.para).email, 
                                  @mensaje2.asunto, 
                                  @mensaje2.texto).deliver
        if @mensaje2.tipo == 'M'
          format.html { redirect_to("/mensajes?tipo=M", :notice => 'Mensaje ha sido enviado.') }
        else
          format.html { redirect_to("/mensajes?tipo=N", :notice => 'Mensaje ha sido enviado.') }        
        end
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @mensaje.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /mensajes/1
  # DELETE /mensajes/1.xml
  def destroy
    @mensaje = Mensaje.find(params[:id])
    @mensaje.destroy

    respond_to do |format|
      format.html { redirect_to(mensajes_url) }
      format.xml  { head :ok }
    end
  end
  
  def mensajeremoto
    
    logger.debug "Mensaje remoto <-----------"
    body = request.body.read
    logger.debug ">>>#{body}<<<"
    
    mensa = JSON.parse(body)

    logger.debug "#{mensa.inspect} <-----------"
    logger.debug  mensa['mensaje']['asunto'] 
    
  end 
  
end
