class HomeController < ApplicationController
  layout "bazar"
  before_filter :require_user, :only => [:index]
  
  # homepage de usuario 
  
  def index
    
    
  end

  # homepage de bazar 
  
  def home    

    # compruebo si está logueado. 
    
    if !current_user.nil?
      # le mandamos a la página de usuario
      
      render :action => "index"
    end

    @total = Cluster.count_by_sql("select sum(empresas) from clusters")      

    # TODO: comprobar si esto sobra 
    
    @ultimas = Bazarcms::Empresa.ultimascreadas
    @actualizadas = Bazarcms::Empresa.ultimasactualizadas

  end 
  
end
