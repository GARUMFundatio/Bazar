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

  def ejemploinfoempresa
    render :layout => 'bazar'
  end 
  
  def ejemploperfiles
    render :layout => 'bazar'
  end

  def ejemplopaises
    render :layout => 'bazar'
  end
  
  # /api/info devuelve la información básica de un bazar
  
  def info
    @info = {}
    @info[:nombre] = Cluster.find(BZ_param("BazarId")).nombre
    @info[:desc] = Cluster.find(BZ_param("BazarId")).desc
    @info[:url] = Cluster.find(BZ_param("BazarId")).url
    # @info[:empresas] = Bazarcms::Empresa.count_by_sql("select count(*) from empresas")
    @info[:empresas] = Bazarcms::Empresa.count_by_sql("select count(*) from users")

    @info[:consultas] = Bazarcms::Empresasconsulta.count_by_sql("select count(*) from empresasconsultas")
    @info[:consultasofertas] = Bazarcms::Ofertasconsulta.count_by_sql("select count(*) from ofertasconsultas")
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
      @info << {:id => empresa.id,
                :nombre => empresa.nombre,
                :url => empresa.url,
                :fundada => empresa.fundada,
                :consultas => Bazarcms::Empresasconsulta.count_by_sql("select count(*) from empresasconsultas where empresa_id = #{empresa.id}")}
    end
    
    respond_to do |format|
        format.html { redirect_to "/api/ejemploempresas"}
        format.xml { render }
        format.json { render :json => @info }
    end
        
  end

  # 
  def infoempresa
    
    @empresa = Bazarcms::Empresa.find_by_id(params[:id])
    
    if !@empresa.nil?
    
      @info = {:id => @empresa.id,
                  :estado => "OK",
                  :nombre => @empresa.nombre,
                  :desc => @empresa.desc,
                  :rating => @empresa.rating,
                  :rating_cliente => @empresa.rating_cliente,
                  :rating_total_cliente => @empresa.rating_total_cliente,
                  :rating_proveedor => @empresa.rating_proveedor,
                  :rating_total_proveedor => @empresa.rating_total_proveedor,
                  :url => @empresa.url,
                  :logo => @empresa.logo.url(:s223),
                  :fundada => @empresa.fundada,
                  :email => User.find(@empresa.id).email,
                  :consultas => Bazarcms::Empresasconsulta.count_by_sql("select count(*) from empresasconsultas where empresa_id = #{@empresa.id}")}
    else
       
      @info = {:id => -1,
                  :estado => "ERROR",
                  :nombre => "No encontrada",
                  :url => "",
                  :fundada => "",
                  :consultas => ""}
    end 
    
    respond_to do |format|
        # no tiene mucho sentido format.html # empresas.html.erb
        format.html { redirect_to "/api/ejemploinfoempresa"}
        format.xml { render }
        format.json { render :json => @info }
    end
        
  end
  
  def infooferta
    
    @oferta = Bazarcms::Oferta.find_by_id(params[:id])
    
    if !@oferta.nil?
    
      @info = @oferta.attributes 
      @info[:estado] = "OK"
      
    else
       
      @info = {:id => -1,
                  :estado => "ERROR",
                  :nombre => "No encontrada"
                }
    end 
    
    respond_to do |format|
        # no tiene mucho sentido format.html # empresas.html.erb
        format.html { redirect_to "/api/ejemploinfooferta"}
        format.xml { render }
        format.json { render :json => @info }
    end
        
  end
  
  
  
  def perfiles
    
    @info = []
    
    @perfiles = Bazarcms::Perfil.all
    for perfil in @perfiles

      if perfil.total_empresas_bazar > 0
        @info << {:id => perfil.codigo,
                  :desc => perfil.desc,
                  :nivel => perfil.nivel,
                  :total_empresas_bazar => perfil.total_empresas_bazar,
                  :total_empresas_mercado => perfil.total_empresas_mercado} 
      end 
      
    end 
    respond_to do |format|
        format.html { redirect_to "/api/ejemploperfiles"}
        format.xml { render }
        format.json { render :json => @info }
    end
        
  end

  def paises
    
    @info = []
    
    @paises = Pais.all
    for pais in @paises

      if pais.total_empresas_bazar > 0
        @info << {:id => pais.id,
                  :codigo => pais.codigo,
                  :descripcion => pais.descripcion,
                  :capital => pais.capital,
                  :total_empresas_bazar => pais.total_empresas_bazar,
                  :total_empresas_mercado => pais.total_empresas_mercado} 
      end 
      
    end 
    respond_to do |format|
        format.html { redirect_to "/api/ejemplopaises"}
        format.xml { render }
        format.json { render :json => @info }
    end
        
  end

  def buscaempresas
    
    query = "*"
    tipo = "OR"
    @info = []
    
    if !params[:q].nil? 
      query = params[:q]
    end 
    
    if !params[:tipo].nil? 
      tipo = params[:tipo]
    end 
    
    resultados = Bazarcms::Empresa.find_with_ferret(query, :limit => :all)
    for resu in resultados 
      @info << resu.attributes
    end 
   
    respond_to do |format|
        format.json { render :json => @info }
    end
    
  end

end
