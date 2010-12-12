class CiudadesController < ApplicationController

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

end