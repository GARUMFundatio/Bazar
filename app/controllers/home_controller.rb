class HomeController < ApplicationController
  layout "bazar"
  before_filter :require_user, :only => [:index]
  
  def index
    
  end

  def home
    @ultimas = Bazarcms::Empresa.ultimascreadas
    @actualizadas = Bazarcms::Empresa.ultimasactualizadas
  end 
  
end
