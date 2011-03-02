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
    
    @mensaje.de = current_user.id
    @mensaje.de_nombre = Bazarcms::Empresa.find_by_id(current_user.id).nombre
    @mensaje.de_email = current_user.email
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
    
    if (@mensaje.bazar_destino.to_i == BZ_param("BazarId").to_i)
      @mensaje.para_nombre = Bazarcms::Empresa.find_by_id(@mensaje.para).nombre
      @mensaje.para_email = User.find_by_id(@mensaje.para).email
    else
      # en este caso el nombre y el email lo fijan en el bazar de destino
      if !params[:nombre].nil?
        @mensaje.para_nombre = params[:nombre]
      else 
        @mensaje.para_nombre = ""      
      end
      @mensaje.para_email = ""
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
    @mensaje.de_nombre = "Sistema"
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
      emp = Bazarcms::Empresa.find_by_id(user.id)
      
      if !emp.nil? 
        @mensaje.para_nombre = emp.nombre
      else 
        @mensaje.para_nombre = ""        
      end 
      
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

    @mensaje = Mensaje.new(params[:mensaje])
    
    respond_to do |format|

      logger.debug "----------> (#{params[:mensaje][:bazar_destino]}) (#{BZ_param("BazarId")})"
      
      if (params[:mensaje][:bazar_destino].to_i == BZ_param("BazarId").to_i)

        # si el mensaje tiene un destinatario local 

        logger.debug "Es un mensaje con destino local!!!"
        
        if @mensaje.save
        
          BazarMailer.enviamensaje(@mensaje.de_email, 
                                    @mensaje.para_email, 
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

        @mensaje.destroy
        
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
    @mensaje2.de_nombre = @mensaje.para_nombre
    @mensaje2.de_email = @mensaje.para_email
    
    @mensaje2.bazar_origen = @mensaje.bazar_destino
    @mensaje2.para = @mensaje.de 
    @mensaje2.para_nombre = @mensaje.de_nombre 
    @mensaje2.para_email = @mensaje.de_email 
    
    @mensaje2.bazar_destino = @mensaje.bazar_origen
    @mensaje2.tipo = @mensaje.tipo
    @mensaje2.leido = nil 
    @mensaje2.borrado = nil
    
    respond_to do |format|
      
      # si es un envio local 
      
      if (@mensaje2.bazar_destino.to_i == BZ_param("BazarId").to_i)
      
        if @mensaje2.save
          BazarMailer.enviamensaje(@mensaje2.de_email, 
                                    @mensaje2.para_email, 
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

      else 
        # enviamos el mensaje al bazar de destino
        
        logger.debug "Enviando el mensaje a #{@mensaje2.bazar_destino}"
        
        dohttppost (@mensaje2.bazar_destino, "/mensajeremoto", @mensaje2.to_json)

        @mensaje2.destroy
        
        format.html { redirect_to("/home") }
      end 

    end
  end

  # DELETE /mensajes/1
  # DELETE /mensajes/1.xml
  def destroy
    @mensaje = Mensaje.find(params[:id])
    tipo = @mensaje.tipo
    @mensaje.destroy

    respond_to do |format|
      format.html { redirect_to(mensajes_url+"?tipo=#{tipo}") }
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
    
    @mensaje = Mensaje.new
    
    @mensaje.tipo = mensa['mensaje']['tipo']
    @mensaje.de = mensa['mensaje']['de']
    @mensaje.de_nombre = mensa['mensaje']['de_nombre']
    @mensaje.de_email = mensa['mensaje']['de_email']
    
    @mensaje.para = mensa['mensaje']['para']
    @mensaje.para_nombre = mensa['mensaje']['para_nombre']
    @mensaje.para_email = User.find(@mensaje.para).email
    
    @mensaje.texto = mensa['mensaje']['texto']
    @mensaje.asunto = mensa['mensaje']['asunto']
    @mensaje.fecha = mensa['mensaje']['fecha']
    @mensaje.bazar_origen = mensa['mensaje']['bazar_origen']
    @mensaje.bazar_destino = mensa['mensaje']['bazar_destino']
     
    @mensaje.save
    
    BazarMailer.enviamensaje(User.find(@mensaje.de).email, 
                              @mensaje.para_email, 
                              @mensaje.asunto, 
                              @mensaje.texto).deliver
    
  end 
  
  def dashboard
    
    @mensajes = Mensaje.where('para = ? and bazar_destino = ? and tipo = "M" and leido is null', current_user.id, BZ_param("BazarId")).order('fecha desc').limit(10)
    @notificaciones = Mensaje.where('para = ? and bazar_destino = ? and tipo = "N" and leido is null', current_user.id, BZ_param("BazarId")).order('fecha desc').limit(10)

    render :layout => false 

  end
  
end
