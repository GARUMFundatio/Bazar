class PaisesController < ApplicationController

  def busqueda
  
    # @perfiles = Perfil.limit(20).where('lower(`desc`) like ? OR lower(ayuda) like ?', '%'+params[:term].downcase+'%', '%'+params[:term].downcase+'%').order('codigo')
 
   terms = params[:term].split(' ')
 
   condi = []
   condi << ""
   tmp = ""
   for term in terms 
   
     if (tmp.length == 0)
       tmp = '(`codigo` like ? OR lower(`descripcion`) like ? OR lower(capital) like ? ) '
     else
       tmp += 'AND (`codigo` like ? OR lower(`descripcion`) like ? OR lower(capital) like ? ) '
     end
     condi << '%'+term+'%'
     condi << '%'+term+'%' 
     condi << '%'+term+'%' 
   end
   condi[0] = tmp
 
   puts "Condiciones de busqueda -----> #{condi.inspect}"
 
   @paises = Pais.find(:all, :conditions => condi, :order => 'descripcion', :limit => 15)
  
   puts @paises.inspect
 
 
    respond_to do |format|
      format.json {
         @info = []
         for pais in @paises
           @info << {:label => "#{pais.descripcion}", :value => "#{pais.descripcion}", :id => "#{pais.id}", :ayuda => "Capital: #{pais.capital} Codigo ISO: #{pais.codigo}", :total => "#{pais.total_empresas_mercado}"}
         end
         render :json =>  @info  }
    end
  
  end

end