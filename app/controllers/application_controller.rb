class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user_session, :current_user, :current_user_is_admin, :current_user_is_dinamizador, :current_user_is_invitado, :BZ_param, :dohttp, :helper_rating_show2
  helper :all
  
  require "net/http"
  require "uri"

  def BZ_param(clave)
    conf = Rails.cache.fetch("BZ#{clave}", :expires_in => 15.minutes) do
      conf = Conf.find_by_nombre(clave)
    end
    
    if !conf.nil?
      return conf.valor
    else
      return "Valor sin definir" 
    end 
  end
    
  def helper_rating_show2(bazar, empresa)
     
     if (bazar.to_i == BZ_param("BazarId").to_i)
       
       empre = Bazarcms::Empresa.find_by_id(empresa)
       
       valor = empre.rating
       nombre = empre.nombre.gsub(' ','_')
       
       url = "/bazarcms/ficharating/#{empresa}?bazar_id=#{bazar}"
       
     else 
       
       # si no es de este bazar 
       valor = 0
       url = ""

     end
     
     val = "#{valor}".split('.')[0]
     str = "<div><a href='#{url}'>" 
     
     for ii in ['1', '2', '3', '4', '5'] 
     
       if (ii > val) 
         str += "<img src='/images/addfav.png'>"
       else 
         str += "<img src='/images/rating.png'>"
       end 
       
     end 
     
     str += "</a></div>"
     str 
   end
  
    
  private
    def current_user_session
      logger.debug "ApplicationController::current_user_session"
      logger.debug "#{@current_user_session.inspect}"
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      logger.debug "ApplicationController::current_user"
      # logger.debug "preguntando por quien es el current user: #{@current_user.inspect}"
      return @current_user if defined?(@current_user)
      logger.debug "No parece que este definido resetamos @current_user"
      @current_user = current_user_session && current_user_session.user
      logger.debug "ahora es current user: #{@current_user.inspect}"

      return @current_user if defined?(@current_user)
    end

    def current_user_is_admin
      logger.debug "ApplicationController::current_user_is_Admin"
      if (!current_user.nil?)
        current_user.roles.select{|i| 
          if (i.rol == 'admin') 
            return true 
          end
          }
      end   
      return false
    end

    def current_user_is_dinamizador
      logger.debug "ApplicationController::current_user_is_dinamizador"
      if (!current_user.nil?)
        current_user.roles.select{|i| 
          if (i.rol == 'dinamizador') 
            return true 
          end
          }
      end   
      return false
    end

    def current_user_is_invitado
      logger.debug "ApplicationController::current_user_is_invitado"
      if (!current_user.nil?)
        current_user.roles.select{|i| 
          if (i.rol == 'invitado') 
            return true 
          end
          }
      end   
      return false
    end

    def require_user
      logger.debug "ApplicationController::require_user"
      unless current_user
        store_location
        flash[:notice] = "Debes entrar en el sistema para poder acceder a esta página"
        redirect_to '/login'
        return false
      end
    end

    def require_no_user
      logger.debug "ApplicationController::require_no_user"
      logger.debug ""
      if current_user
        store_location
        flash[:notice] = "Debes entrar en el sistema para poder acceder a esta página"
        redirect_to "/home"
        return false
      end
    end

    def store_location
      session[:return_to] = request.request_uri
    end

    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end

    
    def dohttppost (bazar, pet, body)
      
      logger.debug "dohttp: bazar #{bazar}: Enviando #{pet}"
    
      cluster = Cluster.find(bazar)
      uri = URI.parse("#{cluster.url}/#{pet}")
      
      post_body = []
      post_body << body 
      
      http = Net::HTTP.new(uri.host, uri.port)
      http.open_timeout = http.read_timeout = 10

      request = Net::HTTP::Post.new(uri.request_uri)
      request.body = post_body.join
      request["Content-Type"] = "text/plain"

      begin 

        res =  Net::HTTP.new(uri.host, uri.port).start {|http| http.request(request) }
        case res
        when Net::HTTPSuccess, Net::HTTPRedirection
          return res.body
        else
          logger.debug "dohttp: ERROR en la petición a #{uri}---------->"+res.error!
          return ""
        end

      rescue Exception => e
        logger.debug "dohttp: Exception leyendo #{cluster.url} Got #{e.class}: #{e}"
        return ""        
      end

    end 

    def dohttpget (bazar, pet)

      logger.debug "dohttp: bazar #{bazar}: Enviando #{pet}"
      
      hydra = Typhoeus::Hydra.new

      cluster = Cluster.find(bazar)
      uri = "#{cluster.url}/#{pet}"

      r = Typhoeus::Request.new(uri, :timeout => 10000)
      
      r.on_complete do |response|
         logger.debug "-------------> "+response.inspect
         case response.curl_return_code
         when 0
           return response.body
         else
           logger.debug "ERROR en la petición ---------->"+response.inspect
           return ""
         end
         
      end
      
      hydra.queue r
      hydra.run

    end 
        
end

