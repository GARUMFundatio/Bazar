class UbicacionesController < ApplicationController
  # GET /ubicaciones
  # GET /ubicaciones.xml
  def index
    @ubicaciones = Ubicacion.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @ubicaciones }
    end
  end

  # GET /ubicaciones/1
  # GET /ubicaciones/1.xml
  def show
    @ubicacion = Ubicacion.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @ubicacion }
    end
  end

  # GET /ubicaciones/new
  # GET /ubicaciones/new.xml
  def new
    @ubicacion = Ubicacion.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @ubicacion }
    end
  end

  # GET /ubicaciones/1/edit
  def edit
    @ubicacion = Ubicacion.find(params[:id])
  end

  # POST /ubicaciones
  # POST /ubicaciones.xml
  def create
    @ubicacion = Ubicacion.new(params[:ubicacion])

    respond_to do |format|
      if @ubicacion.save
        format.html { redirect_to(@ubicacion, :notice => 'Ubicacion was successfully created.') }
        format.xml  { render :xml => @ubicacion, :status => :created, :location => @ubicacion }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @ubicacion.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /ubicaciones/1
  # PUT /ubicaciones/1.xml
  def update
    @ubicacion = Ubicacion.find(params[:id])

    respond_to do |format|
      if @ubicacion.update_attributes(params[:ubicacion])
        format.html { redirect_to(@ubicacion, :notice => 'Ubicacion was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @ubicacion.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /ubicaciones/1
  # DELETE /ubicaciones/1.xml
  def destroy
    @ubicacion = Ubicacion.find(params[:id])
    @ubicacion.destroy

    respond_to do |format|
      format.html { redirect_to(ubicaciones_url) }
      format.xml  { head :ok }
    end
  end
end
