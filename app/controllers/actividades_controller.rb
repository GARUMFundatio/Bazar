class ActividadesController < ApplicationController
  
  layout 'bazar'
  
  # GET /actividades
  # GET /actividades.xml
  
  def index

    # TODO deberíamos definir si solo sacamos toda la actividad del bazar local 
    # o las empresas que sigo o hacer dos vistas
    
    @actividades = Actividad.where("1 = 1").order("fecha desc").paginate(:per_page => 30, :page => params[:page])

    if request.xhr?
      render :partial => @actividades
    end
    
  end


  def list
    
    # TODO Hay que pensar si hacemos esta llamada mucho más abierta y le metemos que se pueda 
    # ver la actividad de cualquier empresa. 
    
    @actividades = Actividad.where("bazar_id = ? and user_id = ?", BZ_param('BazarId'), current_user.id).order("fecha desc").paginate(:per_page => 30, :page => params[:page])

    if request.xhr?
      render :partial => @actividades
    end
    
  end



  # GET /actividades/1
  # GET /actividades/1.xml
  def show
    @actividad = Actividad.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @actividad }
    end
  end

  # GET /actividades/new
  # GET /actividades/new.xml
  def new
    @actividad = Actividad.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @actividad }
    end
  end

  # GET /actividades/1/edit
  def edit
    @actividad = Actividad.find(params[:id])
  end

  # POST /actividades
  # POST /actividades.xml
  def create
    @actividad = Actividad.new(params[:actividad])

    respond_to do |format|
      # no se pueden crear más que desde la aplicacion if @actividad.save
        format.html { redirect_to(@actividad, :notice => 'Actividad was successfully created.') }
        format.xml  { render :xml => @actividad, :status => :created, :location => @actividad }
    end
  end

  # PUT /actividades/1
  # PUT /actividades/1.xml

  def update
    @actividad = Actividad.find(params[:id])

    respond_to do |format|
        format.html { redirect_to(@actividad, :notice => 'Actividad was successfully updated.') }
        format.xml  { head :ok }
    end
  end

  # DELETE /actividades/1
  # DELETE /actividades/1.xml
  def destroy
    @actividad = Actividad.find(params[:id])
    # jt securizado @actividad.destroy

    respond_to do |format|
      format.html { redirect_to(actividades_url) }
      format.xml  { head :ok }
    end
  end
  
  def dashboard 
    
    @ultimas = Actividad.where("1 = 1").order("fecha desc").limit(10)
    @total = Actividad.count_by_sql("select count(*) from actividades")
    
    respond_to do |format|
      format.html { render :layout => false }
    end
  end
  
  def rss
    @actividades = Actividad.where("bazar_id = ?", BZ_param('BazarId')).order("fecha desc").limit(20)
    render :layout => false
  end
  
end
