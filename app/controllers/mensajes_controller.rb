class MensajesController < ApplicationController
  # GET /mensajes
  # GET /mensajes.xml
  def index
    @mensajes = Mensaje.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @mensajes }
    end
  end

  # GET /mensajes/1
  # GET /mensajes/1.xml
  def show
    @mensaje = Mensaje.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @mensaje }
    end
  end

  # GET /mensajes/new
  # GET /mensajes/new.xml
  def new
    @mensaje = Mensaje.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @mensaje }
    end
  end

  # GET /mensajes/1/edit
  def edit
    @mensaje = Mensaje.find(params[:id])
  end

  # POST /mensajes
  # POST /mensajes.xml
  def create
    @mensaje = Mensaje.new(params[:mensaje])

    respond_to do |format|
      if @mensaje.save
        format.html { redirect_to(@mensaje, :notice => 'Mensaje was successfully created.') }
        format.xml  { render :xml => @mensaje, :status => :created, :location => @mensaje }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @mensaje.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /mensajes/1
  # PUT /mensajes/1.xml
  def update
    @mensaje = Mensaje.find(params[:id])

    respond_to do |format|
      if @mensaje.update_attributes(params[:mensaje])
        format.html { redirect_to(@mensaje, :notice => 'Mensaje was successfully updated.') }
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
end
