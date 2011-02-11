require "rexml/document"

class ApiController < ApplicationController
    
  def info
    @info = {}
    @info[:nombre] = Cluster.find(BZ_param("BazarId")).nombre
    @info[:desc] = Cluster.find(BZ_param("BazarId")).desc
    @info[:url] = Cluster.find(BZ_param("BazarId")).url
    @info[:empresas] = Bazarcms::Empresa.count_by_sql("select count(*) from empresas")
    @info[:consultas] = Bazarcms::Empresasconsulta.count_by_sql("select count(*) from empresasconsultas")
    @info[:clusteractivos] = Cluster.count_by_sql("select count(*) from clusters where activo = 'S' ")
    
    respond_to do |format|
        format.html # info.html.erb
        format.xml { render :xml => @info }
        format.json { render :json => @info }
    end
        
  end

end