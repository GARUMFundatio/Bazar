class UsersController < ApplicationController
  
  layout "bazar"
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
      format.xml  { render :xml => @user }
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
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
    
  end 
  
  def altaregistrarse
    params[:user][:rol_ids] ||= [2]
    @user = User.new(params[:user])
    
    respond_to do |format|
      if @user.save

        # avisamos al usuario de que se ha registrado
        
        BazarMailer.confirmacion_registro(@user).deliver      
        
        # avisamos al admin de que hay una nueva alta
        
        Mail.deliver do
              to "Admin Bazar <#{Conf.find_by_nombre('CorreoAdmin').valor}>"
            from 'No replay <noreplay@bazar.com>'
         subject "Nuevo Usuario en #{Conf.find_by_nombre('Titular').valor}"
            body "
                        
            En estos momentos hay #{User.all.count} usuarios registrados.
            
            "
        end
        
        format.html { redirect_to('/home', :notice => 'Se ha creado correctamente el usuario.') }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "registrarse" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
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
