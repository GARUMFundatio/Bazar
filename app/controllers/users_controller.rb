class UsersController < ApplicationController
  
  layout "bazar"
  theme "bazar"
  
  before_filter :require_user, :only => [:index, :edit, :create, :update, :new ]

  def index
 
 
    orden = "id"
    
    if ( params[:orden].nil? )
      puts "no hay orden"
      orden = "id"
    else 
      case params[:orden]
      when "correo-asc"
        orden = "email asc"
      when "correo-desc"
        orden = "email desc"
      when "conexiones-asc"
        orden = "login_count asc"
      when "conexiones-desc"
        orden = "login_count desc"
      when "last-asc"
        orden = "last_login_at asc"
      when "last-desc"
        orden = "last_login_at desc"
      end        
    end 
    
    @users = User.where("1 = 1").order(orden).paginate(:page => params[:page], :per_page => 50)

    
    puts @users.size
    respond_to do |format|
      if current_user_is_admin || current_user_is_dinamizador
        format.html 
      else 
        redirect_to "/home"
      end
            
    end
  end

  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  def new
    @user = User.new
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    if (current_user_is_admin || current_user_is_dinamizador)
      @user = User.find(params[:id])
    else 
      @user = User.find(current_user.id)      
    end
  
  end

  def create
    params[:user][:rol_ids] ||= []
    @user = User.new(params[:user])
    # @user.rol_ids = params[:rol_ids] || Array.new
    respond_to do |format|
      if @user.save

        BazarMailer.confirmacion_registro(@user).deliver      
        
        format.html { redirect_to(@user, :notice => 'Se ha creado correctamente el usuario.') }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def registrarse

    @user = User.new
    render :layout => false 
    
  end 
  
  def altaregistrarse
    params[:user][:rol_ids] ||= [2]
    @user = User.new(params[:user])
    
    if @user.save
      
      empresa = Bazarcms::Empresa.new 
      empresa.id = @user.id 
      empresa.user_id = @user.id 
      empresa.nombre = "Escriba su nombre Aquí"
      empresa.desc = ""
      empresa.fundada = 2012
      empresa.moneda = 0 
      empresa.url = ""
      empresa.rating = 0 
      empresa.total_favoritos = 0 
      empresa.total_mostradas = 0 
      empresa.rating_cliente = 0 
      empresa.rating_proveedor = 0 
      empresa.rating_total_cliente = 0 
      empresa.rating_total_proveedor = 0
      empresa.logo_file_name = ""
      empresa.sector = "01"
      empresa.ambito = 2
      empresa.save 
      
      datos = Bazarcms::Empresasdato.new
      datos.empresa_id = @user.id 
      datos.periodo = 2011
      datos.empleados = 0 
      datos.ventas = 0
      datos.compras = 0 
      datos.resultados = 0 
      datos.save 
      
      # avisamos al usuario de que se ha registrado
      
      BazarMailer.confirmacion_registro(@user).deliver      
      
      # avisamos al admin de que hay una nueva alta
      
      begin 
        Mail.deliver do
              to "Admin Bazar <#{Conf.find_by_nombre('CorreoAdmin').valor}>"
            from 'No replay <noreplay@bazar.com>'
         subject "Nuevo Usuario en #{Conf.find_by_nombre('Titular').valor}"
            body "
                      
            En estos momentos hay #{User.all.count} usuarios registrados.
          
           "
        end
      rescue
        logger.debug "Se ha producido un error al intentar avisar al administrador de una nueva alta!!!"
      end

      render :layout => false 

    else

      render :action => "registrarse", :layout => false

    end
    
  end


  def update
    puts params.inspect
    params[:user][:rol_ids] ||= []
    @user = User.find(params[:id])
    puts params.inspect 
    @user.rol_ids = params[:rol_ids] || Array.new
    
    respond_to do |format|
      if @user.update_attributes(params[:user])
        # BazarMailer.confirmacion_registro(@user).deliver      
        
        if (current_user_is_admin || current_user_is_dinamizador)
          format.html { redirect_to(users_url) }
        else
          format.html { redirect_to('/home') }        
        end 
        
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    # @user = User.find(params[:id])
    
    # TODO: no se pueden borrar los usuarios por las buenas. 
    # hay que definir la política de borrado de toda la información relacionada. 
    
    # @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
end
