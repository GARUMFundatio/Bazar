class ClustersController < ApplicationController

  before_filter :require_user, :only => [:index,:edit,:activar,:create,:update, :destroy]

  layout "bazar"
  require "typhoeus"
  
  def index
    @clusters = Cluster.where("1 = 1").paginate(:page => params[:page], :per_page => 50)

    respond_to do |format|
      if current_user_is_admin
        format.html
      else 
        redirect_to '/home'
      end 
      # format.xml  { render :xml => @clusters }
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
      if current_user_is_admin
        format.html
      else 
        redirect_to '/home'
      end 
    
    end
  end

  def edit
    
    # los clusters no se editan
    
    # @cluster = Cluster.find(params[:id])
    
    respond_to do |format|
      if current_user_is_admin
        format.html { redirect_to(clusters_url) }
      else 
        redirect_to '/home'
      end 
      format.xml  { head :ok }
    end
    
  end

  def create

    # los clusters se dan de alta en el directorio 
    
    respond_to do |format|
      format.html { redirect_to(clusters_url, :notice => 'Cluster was successfully created.') }
    end
  end

  def update
    
    # Solo se puede activar y desactivar y no con este método

    respond_to do |format|
      format.html { redirect_to(clusters_url) }
      format.xml  { head :ok }
    end
  end

  def activar 

    # solo los usuarios con rol de admin pueden activar o desactivar bazares. 
    
    if current_user_is_admin 

      @cluster = Cluster.find(params[:id])
      @cluster.activo = "S"
      @cluster.save
      
      puts "Activado el cluster #{params[:id]}"
    end 
    
    respond_to do |format|
      format.html { redirect_to(clusters_url) }
      format.xml  { head :ok }
    end

  end
  
  def destroy
    
    # solo los usuarios con rol de admin pueden activar o desactivar bazares. 
    
    if current_user_is_admin 
      
      @cluster = Cluster.find(params[:id])
      @cluster.activo = "N"
      @cluster.save

    end 
    
    respond_to do |format|
      format.html { redirect_to(clusters_url) }
      format.xml  { head :ok }
    end
  end
  
  def updateinfo
    
    hydra = Typhoeus::Hydra.new
    
    uri = "http://directorio.garumfundatio.org/clusters.json"

    r = Typhoeus::Request.new(uri, :timeout => 5000)
      
    r.on_complete do |response|
      logger.debug "-------------> "+response.inspect
      case response.curl_return_code
      when 0
        
        clusters = JSON.parse(response.body)
        puts ("#{clusters.inspect} <---------")
 
        clusters.each{ |key|
          puts ("#{key.inspect}")
          puts ("#{key['cluster'].inspect} <------ datos")
          puts ("#{key['cluster']['id']}")
        
          cluster = Cluster::find_by_id(key['cluster']['id'])
          if (cluster == nil)
            puts ("nuevo cluster #{key['cluster']['id']}")
            cluster = Cluster::new
            cluster.id = key['cluster']['id']
            cluster.nombre = key['cluster']['nombre']
            cluster.desc = key['cluster']['desc']
            cluster.empresas = key['cluster']['empresas']
            cluster.url = key['cluster']['url']
            cluster.activo = 'S'
            cluster.miclave = 'secreta'
            cluster.suclave = 'secreta'
            cluster.created_at = key['cluster']['created_at']
            cluster.updated_at = key['cluster']['updated_at']         
            cluster.save
          else
            puts("actualizo cluster #{key['cluster']['id']}")
            cluster.nombre = key['cluster']['nombre']
            cluster.desc = key['cluster']['desc']
            cluster.empresas = key['cluster']['empresas']
            cluster.url = key['cluster']['url']
            cluster.updated_at = key['cluster']['updated_at']         
            cluster.save          
          end
        }
      else
        logger.debug "Se ha producido un error"
      end
    end 
    
    logger.debug "encolado "+DateTime.now.to_s
    
    hydra.queue r
    hydra.run

    logger.debug "servido "+DateTime.now.to_s    
    
    render 

  end 
  
end
