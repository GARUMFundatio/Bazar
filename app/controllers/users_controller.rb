class UsersController < ApplicationController

  layout "bazar"

  def index
    @users = User.all
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
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
end
