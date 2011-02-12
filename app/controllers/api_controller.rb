require "rexml/document"

class ApiController < ApplicationController
  
  # introducción al API del proyecto Bazar
  
  def index 
    render :layout => 'bazar'
  end 
  
  # ejemplos API del proyecto Bazar
  
  def ejemplos
    render :layout => 'bazar'
  end 
  
  def ejemploinfo
    render :layout => 'bazar'
  end 

  def ejemploempresas
    render :layout => 'bazar'
  end 
  
  # /api/info devuelve la información básica de un bazar
  
  def info
    @info = {}
    @info[:nombre] = Cluster.find(BZ_param("BazarId")).nombre
    @info[:desc] = Cluster.find(BZ_param("BazarId")).desc
    @info[:url] = Cluster.find(BZ_param("BazarId")).url
    @info[:empresas] = Bazarcms::Empresa.count_by_sql("select count(*) from empresas")
    @info[:consultas] = Bazarcms::Empresasconsulta.count_by_sql("select count(*) from empresasconsultas")
    @info[:clustersactivos] = Cluster.count_by_sql("select count(*) from clusters where activo = 'S' ")
    
    respond_to do |format|
        format.html { render :layout => false}
        format.xml { render }
        format.json { render :json => @info }
    end
        
  end
  
  # /api/info devuelve la información de las empresas de un bazar
  
  def empresas
    
    @info = []
    @empresas = Bazarcms::Empresa.all
    
    for empresa in @empresas
      @info << {:nombre => empresa.nombre,
                :url => empresa.url,
                :fundada => empresa.fundada,
                :consultas => Bazarcms::Empresasconsulta.count_by_sql("select count(*) from empresasconsultas where empresa_id = #{empresa.id}")}
    end
    
    respond_to do |format|
        # no tiene mucho sentido format.html # empresas.html.erb
        format.xml { render }
        format.json { render :json => @info }
    end
        
  end

  

end