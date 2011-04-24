class ClustersController < ApplicationController

  before_filter :require_user, :only => [:index,:edit,:activar,:create,:update, :destroy, :updateinfo]

  layout "bazar"
  
  def index
    @clusters = Cluster.all.paginate(:page => params[:page], :per_page => 15)

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
    
    # los clusters no se editan
    
    # @cluster = Cluster.find(params[:id])
    
    respond_to do |format|
      format.html { redirect_to(clusters_url) }
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
    
    uri = URI.parse("http://directorio.garumfundatio.org/clusters.json")

    post_body = []
    post_body << "Content-Type: text/plain\r\n"

    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    request.body = post_body.join
    request["Content-Type"] = "text/plain"
  
    res = Net::HTTP.new(uri.host, uri.port).start {|http| http.request(request) }
    case res
    when Net::HTTPSuccess, Net::HTTPRedirection
      #puts "fue bien (#{res.body})"
      
      clusters = JSON.parse(res.body)
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
          puts ("actualizo cluster #{key['cluster']['id']}")
          cluster.nombre = key['cluster']['nombre']
          cluster.desc = key['cluster']['desc']
          cluster.empresas = key['cluster']['empresas']
          cluster.url = key['cluster']['url']
          cluster.updated_at = key['cluster']['updated_at']         
          cluster.save          
        end

      }
 
    else
      puts res.error!
    end

    render 

  end 
  
end
