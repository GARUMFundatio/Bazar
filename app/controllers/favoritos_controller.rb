class FavoritosController < ApplicationController
  # GET /favoritos
  # GET /favoritos.xml
  def index
    @favoritos = Favorito.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @favoritos }
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
      @fav.user_id = current_user.id
      @fav.save 
    else 
      logger.debug "Ya estaba en favoritos!!! #{params.inspect}"
    end 
    @pre = params[:pre]
    render :layout => false  
  end

  def delfav
    @fav = Favorito.find_by_user_id_and_bazar_id_and_empresa_id(current_user.id, params[:bazar], params[:empresa])

    if !@fav.nil? 
      @fav.destroy 
    else 
      logger.debug "No estaba en favoritos!!! #{params.inspect}"
    end 
    
    @pre = params[:pre]
    render :layout => false  
        
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
  
  def dashboard 
    @favoritos = Favorito.where("user_id = ?", current_user.id).order("fecha desc")
    respond_to do |format|
      format.html { render :layout => false }
    end
  end
  
end
