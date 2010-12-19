class ClustersController < ApplicationController

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
