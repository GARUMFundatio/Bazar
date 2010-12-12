class ClustersController < ApplicationController

  layout "bazar"
  
  def index
    @clusters = Cluster.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @clusters }
    end
  end

  def show
    @cluster = Cluster.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @cluster }
    end
  end

  def new
    @cluster = Cluster.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @cluster }
    end
  end

  def edit
    @cluster = Cluster.find(params[:id])
  end

  def create
    @cluster = Cluster.new(params[:cluster])

    respond_to do |format|
      if @cluster.save
        format.html { redirect_to(clusters_url, :notice => 'Cluster was successfully created.') }
        format.xml  { render :xml => @cluster, :status => :created, :location => @cluster }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @cluster.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @cluster = Cluster.find(params[:id])

    respond_to do |format|
      if @cluster.update_attributes(params[:cluster])
        format.html { redirect_to(clusters_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @cluster.errors, :status => :unprocessable_entity }
      end
    end
  end

  def activar 
      @cluster = Cluster.find(params[:id])
      @cluster.activo = "S"
      @cluster.save
      puts "Activado el cluster #{params[:id]}"
      respond_to do |format|
        format.html { redirect_to(clusters_url) }
        format.xml  { head :ok }
      end
  end
  
  def destroy
    @cluster = Cluster.find(params[:id])
    @cluster.activo = "N"
    @cluster.save

    respond_to do |format|
      format.html { redirect_to(clusters_url) }
      format.xml  { head :ok }
    end
  end
  
end
