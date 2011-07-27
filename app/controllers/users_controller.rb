class UsersController < ApplicationController

  before_filter :require_user
  
  layout "bazar"

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
    
    @users = User.where ("1 = 1").order(orden).paginate(:page => params[:page], :per_page => 50)

    
    puts @users.size
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
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
    @user = User.find(params[:id])
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

  def update
    puts params.inspect
    params[:user][:rol_ids] ||= []
    @user = User.find(params[:id])
    puts params.inspect 
    @user.rol_ids = params[:rol_ids] || Array.new
    
    respond_to do |format|
      if @user.update_attributes(params[:user])
        BazarMailer.confirmacion_registro(@user).deliver      
        format.html { redirect_to(users_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @user = User.find(params[:id])
    
    # TODO: no se pueden borrar los usuarios por las buenas. 
    # hay que definir la política de borrado de toda la información relacionada. 
    
    # @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
end
