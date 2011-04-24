class CiudadesController < ApplicationController

  layout "bazar"
  def busqueda
    @ciudades = Ciudad.limit(10).where('lower(descripcion) like ?', params[:term].downcase+'%')
    puts @ciudades.inspect
    respond_to do |format|
      format.json {
         @info = []
         for ciudad in @ciudades
           @info << {:label => "#{ciudad.descripcion}, #{ciudad.pais.descripcion}", :value => "#{ciudad.descripcion}", :id => "#{ciudad.id}"}
         end
         render :json =>  @info  }
    end
    
  end

  def index
    @ubicaciones = Bazarcms::Ubicacion.where('1 = 1').order('ciudad_id')  
    render :layout => true 
  end 
  
  def show
    @ciudad = Ciudad.find(params[:id])  
    render :layout => true
  end 
  
end