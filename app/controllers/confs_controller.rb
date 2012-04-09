class ConfsController < ApplicationController
  # GET /confs
  # GET /confs.xml
  
  layout "bazar"
  before_filter :require_user
  
  def index
    @confs = Conf.order(:grupo_id)
    @grupos = Gruposconf.all
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @confs }
    end
  end

  def bulk
    @confs = Conf.order(:grupo_id)
    @grupos = Gruposconf.all
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @confs }
    end
  end
  
  # GET /confs/1
  # GET /confs/1.xml
  def show
    @conf = Conf.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @conf }
    end
  end

  # GET /confs/new
  # GET /confs/new.xml
  def new
    @conf = Conf.new
    @grupos = Gruposconf.all
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @conf }
    end
  end

  # GET /confs/1/edit
  def edit
    @conf = Conf.find(params[:id])
    @grupos = Gruposconf.all
  end

  # POST /confs
  # POST /confs.xml
  def create
    @conf = Conf.new(params[:conf])
    
    respond_to do |format|
      if @conf.save
        format.html { redirect_to(@conf, :notice => 'Parametro actualizado correctamente.') }
        format.xml  { render :xml => @conf, :status => :created, :location => @conf }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @conf.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /confs/1
  # PUT /confs/1.xml
  def update
    @conf = Conf.find(params[:id])
    
    # @conf.grupo_id = params[:grupo_id][:id]
    
    respond_to do |format|
      if @conf.update_attributes(params[:conf])
        format.html { redirect_to(@conf, :notice => 'Parametro actualizado correctamente') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @conf.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /confs/1
  # DELETE /confs/1.xml
  def destroy
    @conf = Conf.find(params[:id])
    @conf.destroy

    respond_to do |format|
      format.html { redirect_to(confs_url) }
      format.xml  { head :ok }
    end
  end
end
