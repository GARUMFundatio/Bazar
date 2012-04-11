class ConfsController < ApplicationController
  # GET /confs
  # GET /confs.xml
  
  layout "bazar"
  before_filter :require_user
  
  def index
    @confs = Conf.order(:grupo_id)
    @grupos = Gruposconf.all
        
    if (current_user_is_admin )
      render 
    else 
      redirect_to "/home"
    end 
  end

  def bulk
    @confs = Conf.order(:grupo_id)
    @grupos = Gruposconf.all
    
    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  def show
    @conf = Conf.find(params[:id])

    respond_to do |format|
      if (current_user_is_admin )
        format.html # show.html.erb
      else 
        format.html { redirect_to "/home" }
      end 
    end
  end

  def new
    redirect_to "/home"
  end

  def edit
    @conf = Conf.find(params[:id])
    @grupos = Gruposconf.all
    
    if (current_user_is_admin )
      render
    else 
      redirect_to "/home"
    end 
  end

  def create
    @conf = Conf.new(params[:conf])
    
    respond_to do |format|
      if (current_user_is_admin )
        if @conf.save
          format.html { redirect_to(@conf, :notice => 'Parametro actualizado correctamente.') }
        else
          format.html { render :action => "new" }
        end
      else 
        format.html { redirect_to "/home" }
      end 
    end
  end

  def update
    @conf = Conf.find(params[:id])
        
    respond_to do |format|
      if (current_user_is_admin )
      
        if @conf.update_attributes(params[:conf])
          format.html { redirect_to(@conf, :notice => 'Parametro actualizado correctamente') }
        else
          format.html { render :action => "edit" }
        end
      else 
        format.html { redirect_to "/home" }
      end 
    end
  end

  def destroy
    redirect_to "/home"
  end
  
end
