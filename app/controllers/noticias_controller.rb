require "rexml/document"

class NoticiasController < ApplicationController
  
  before_filter :require_no_user, :only => [:rss]
  before_filter :require_user, :only => [:index,:show,:edit,:create,:update, :destroy]
  
  # GET /noticias
  # GET /noticias.xml
  
  layout "bazar"
  def index
    @noticias = Noticia.where("1 = 1").order("fecha desc").paginate(:page => params[:page], :per_page => 15)

    respond_to do |format|
      if current_user_is_admin || current_user_is_dinamizador
        format.html # index.html.erb
        format.xml { render :xml => @noticias }
      else 
        redirect_to("/home")
      end 
    end
    
  end

  def rss
    @noticias = Noticia.where("1 = 1").order("fecha desc").paginate(:page => params[:page], :per_page => 15)
    render :layout => false
  end 
  
  # GET /noticias/1
  # GET /noticias/1.xml
  def show
    @noticia = Noticia.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @noticia }
      
    end
  end

  # GET /noticias/new
  # GET /noticias/new.xml
  def new
    @noticia = Noticia.new
    @noticia.visible = 1
    @noticia.fecha = DateTime.now
    respond_to do |format|
      if current_user_is_admin || current_user_is_dinamizador
        format.html # index.html.erb
        format.xml { render :xml => @noticias }
      else 
        redirect_to("/home")
      end 
    end

  end

  # GET /noticias/1/edit
  def edit
    @noticia = Noticia.find(params[:id])
  end

  # POST /noticias
  # POST /noticias.xml
  def create
    @noticia = Noticia.new(params[:noticia])
    f = params[:noticia][:fecha].split(/-\//)
    params[:noticia][:fecha]="#{f[2]}-#{f[1]}-#{f[0]}"
    
    respond_to do |format|
      if current_user_is_admin || current_user_is_dinamizador
        if @noticia.save
          format.html { redirect_to(noticias_path) }
          format.xml  { render :xml => @noticia, :status => :created, :location => @noticia }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @noticia.errors, :status => :unprocessable_entity }
        end
      else 
        redirect_to("/home")       
      end
    
    end
  end

  # PUT /noticias/1
  # PUT /noticias/1.xml
  def update
    @noticia = Noticia.find(params[:id])
    f = params[:noticia][:fecha].split(/-\//)
    params[:noticia][:fecha]="#{f[2]}-#{f[1]}-#{f[0]}"
    logger.debug "-----> #{f.inspect} fecha  #{params.inspect}"
    # @noticia.fecha = params[:fecha]
    
    respond_to do |format|
      if current_user_is_admin || current_user_is_dinamizador
        if @noticia.update_attributes(params[:noticia])
          format.html { redirect_to(noticias_path) }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @noticia.errors, :status => :unprocessable_entity }
        end
      else
        redirect_to("/home")
      end
    end
  end

  # DELETE /noticias/1
  # DELETE /noticias/1.xml
  def destroy
    @noticia = Noticia.find(params[:id])
    @noticia.destroy

    respond_to do |format|
      if current_user_is_admin || current_user_is_dinamizador
      
        format.html { redirect_to(noticias_url) }
        format.xml  { head :ok }
      else
        redirect_to("/home") 
      end
    end
  end
end
