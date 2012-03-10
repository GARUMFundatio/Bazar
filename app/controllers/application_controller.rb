class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user_session, :current_user, :current_user_is_admin, :current_user_is_dinamizador, 
            :current_user_is_invitado, :BZ_param, :dohttp, :helper_rating_show2, :helper_formatea, :datos_empresa_remota,
            :logo_helper, :logo_grande_helper, :datos_oferta_remota, :helper_rating_show_ng, :helper_rating_show_detail_ng
  
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
       
       if !empre.nil? 
         valor = empre.rating
         nombre = empre.nombre.gsub(' ','_')
       else 
         valor = 0
         nombre = "Sin rating"
       end 
       
       url = "/bazarcms/ficharating/#{empresa}?bazar_id=#{bazar}"
       
     else 
       
       # si no es de este bazar le pedimos al otro bazar que nos 
       # de su rating. 
       # TODO JT esto habría que cachearlo para optimizar las comunicaciones
       
       res = Rails.cache.fetch("emp-json-#{bazar}-#{empresa}", :expires_in => 8.hours) do
         logger.debug "----> no estaba cacheado emp-json-#{bazar}-#{empresa}"
         res = dohttpget(bazar, "/api/infoempresa.json/#{empresa}")
       end
       
       logger.debug "json empresa ------->"+res.inspect
       if (res.length > 1)
         begin
           empre = JSON.parse(res)
         rescue 
           
           logger.debug "OJO ---> No es parseable este json: #{res} de emp-json-#{bazar}-#{empresa}"
           valor = 0
           expire_fragment "emp-json-#{bazar}-#{empresa}"
          else
            logger.debug "json empresa2 ------->"+empre.inspect

            if (!empre['rating'].nil?)
              logger.debug "json empresa3 ------->#{empre['rating']}"
              valor = empre['rating']
            else 
              valor = 0
            end 
          end
       else 
         valor = 0
       end 
       
       url = "/bazarcms/ficharating/#{empresa}?bazar_id=#{bazar}"

     end
     
     val = "#{valor}".split('.')[0]
     str = "<div><a href='#{url}' title='Ver el Rating de esta empresa'>" 
     
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

   def helper_rating_show_ng(bazar, empresa)

      if (bazar.to_i == BZ_param("BazarId").to_i)

        empre = Bazarcms::Empresa.find_by_id(empresa)

        if !empre.nil? 
          valor = empre.rating
          nombre = empre.nombre.gsub(' ','_')
        else 
          valor = 0
          nombre = "Sin rating"
        end 

        url = "/bazarcms/ficharating/#{empresa}?bazar_id=#{bazar}"

      else 

        # si no es de este bazar le pedimos al otro bazar que nos 
        # de su rating. 
        # TODO JT esto habría que cachearlo para optimizar las comunicaciones

        res = Rails.cache.fetch("emp-json-#{bazar}-#{empresa}", :expires_in => 8.hours) do
          logger.debug "----> no estaba cacheado emp-json-#{bazar}-#{empresa}"
          res = dohttpget(bazar, "/api/infoempresa.json/#{empresa}")
        end

        logger.debug "json empresa ------->"+res.inspect
        if (res.length > 1)
          begin
            empre = JSON.parse(res)
          rescue 

            logger.debug "OJO ---> No es parseable este json: #{res} de emp-json-#{bazar}-#{empresa}"
            valor = 0
            expire_fragment "emp-json-#{bazar}-#{empresa}"
           else
             logger.debug "json empresa2 ------->"+empre.inspect

             if (!empre['rating'].nil?)
               logger.debug "json empresa3 ------->#{empre['rating']}"
               valor = empre['rating']
             else 
               valor = 0
             end 
           end
        else 
          valor = 0
        end 

        url = "/bazarcms/ficharating/#{empresa}?bazar_id=#{bazar}"

      end

      val = "#{valor}".split('.')[0]
      str = ""

      for ii in ['1', '2', '3', '4', '5'] 

        if (ii > val) 
          str += "<img class='fichaempresa-rating-img' src='"+current_theme_image_path('estrellawhite40.png')+"'>"
        else 
          str += "<img class='fichaempresa-rating-img' src='"+current_theme_image_path('estrellawhite.png')+"'>"
        end 

      end 

      str += ""
      str 
    end

    def helper_rating_show_detail_ng(bazar, empresa)

      logger.debug "Detalle de rating para bazar #{bazar} empresa #{empresa}"
       if (bazar.to_i == BZ_param("BazarId").to_i)

         ratings = Bazarcms::Rating.where("1 = 1")

         str = ""
         
         valores = {"1" => 0, "2" => 0, "3" => 0, "4" => 0, "5" => 0}
         total = 0 
         
         for rating in ratings
           
           logger.debug "rating: "+rating.inspect
           tipo = ""
           tipo = "ori" if (rating.ori_bazar_id == bazar.to_i && rating.ori_empresa_id == empresa.to_i)
           tipo = "des" if (rating.des_bazar_id == bazar.to_i && rating.des_empresa_id == empresa.to_i)
              
           if tipo == ""
             logger.debug "Me lo salto"
             next
           end 
             
           if (tipo == "ori")
              valor = rating.ori_valor 
           else 
              valor = rating.des_valor 
           end 
           
           if valor.nil?
              logger.debug "No tiene valor!!"
              next
           else 
              valores["#{valor}".split('.')[0]] += 1
           end 
           total += 1 
           
           logger.debug "Entra: id #{rating.id} valor #{valor}"
           
         end
         
         str += "<div class='fichaempresa-rating-show-detail'> #{total} "+t(:text_empresas_han_votado)+"</div>" 
         
         for valor in valores 
           
           str += "<div class='fichaempresa-rating-show-detail'>"+t(:text_puntuar_con) 
           val = "#{valor}".split('.')[0]
           for ii in ['1', '2', '3', '4', '5'] 

             if (ii > val) 
               str += "<img class='fichaempresa-rating-img' src='"+current_theme_image_path('estrellawhite40.png')+"'>"
             else 
               str += "<img class='fichaempresa-rating-img' src='"+current_theme_image_path('estrellawhite.png')+"'>"
             end 

           end 
           str += "</div>"
         end 
         
       else 

         # si no es de este bazar le pedimos al otro bazar que nos 
         # de su rating. 
         # TODO JT esto habría que cachearlo para optimizar las comunicaciones

         res = Rails.cache.fetch("emp-json-#{bazar}-#{empresa}", :expires_in => 8.hours) do
           logger.debug "----> no estaba cacheado emp-json-#{bazar}-#{empresa}"
           res = dohttpget(bazar, "/api/infoempresa.json/#{empresa}")
         end

         logger.debug "json empresa ------->"+res.inspect
         if (res.length > 1)
           begin
             empre = JSON.parse(res)
           rescue 

             logger.debug "OJO ---> No es parseable este json: #{res} de emp-json-#{bazar}-#{empresa}"
             valor = 0
             expire_fragment "emp-json-#{bazar}-#{empresa}"
            else
              logger.debug "json empresa2 ------->"+empre.inspect

              if (!empre['rating'].nil?)
                logger.debug "json empresa3 ------->#{empre['rating']}"
                valor = empre['rating']
              else 
                valor = 0
              end 
            end
         else 
           valor = 0
         end 

         url = "/bazarcms/ficharating/#{empresa}?bazar_id=#{bazar}"

       end


       str += ""
       str 
     end

   def logo_grande_helper(bazar, empresa)

      if (bazar.to_i == BZ_param("BazarId").to_i)

        empre = Bazarcms::Empresa.find_by_id(empresa)

        if !empre.nil? 
          url = empre.logo.url(:s223)
        else 
          url = nil
        end 

      else 

        # si no es de este bazar le pedimos al otro bazar que nos de su logo

        res = Rails.cache.fetch("emp-json-#{bazar}-#{empresa}", :expires_in => 8.hours) do
          logger.debug "----> no estaba cacheado emp-json-#{bazar}-#{empresa}"
          res = dohttpget(bazar, "/api/infoempresa.json/#{empresa}")
        end

        logger.debug "json empresa ------->"+res.inspect
        if (res.length > 1)
          begin
            empre = JSON.parse(res)
          rescue 

            logger.debug "OJO ---> No es parseable este json: #{res} de emp-json-#{bazar}-#{empresa}"
            url = nil
            expire_fragment "emp-json-#{bazar}-#{empresa}"
           else
             logger.debug "json empresa2 ------->"+empre.inspect

             if (!empre['logo'].nil?)
               logger.debug "json empresa3 ------->#{empre['logo']}"
               cluster = Cluster.find(bazar)
               url = "#{cluster.url}/"+empre['logo']
             else 
               url = nil
             end 
           end
        else 
          url = nil
        end 

      end
      
      url
    end

    def logo_helper(bazar, empresa)

       if (bazar.to_i == BZ_param("BazarId").to_i)

         empre = Bazarcms::Empresa.find_by_id(empresa)

         if !empre.nil? 
           url = empre.logo.url(:thumb)
         else 
           url = nil
         end 

       else 

         # si no es de este bazar le pedimos al otro bazar que nos de su logo

         res = Rails.cache.fetch("emp-json-#{bazar}-#{empresa}", :expires_in => 8.hours) do
           logger.debug "----> no estaba cacheado emp-json-#{bazar}-#{empresa}"
           res = dohttpget(bazar, "/api/infoempresa.json/#{empresa}")
         end

         logger.debug "json empresa ------->"+res.inspect
         if (res.length > 1)
           begin
             empre = JSON.parse(res)
           rescue 

             logger.debug "OJO ---> No es parseable este json: #{res} de emp-json-#{bazar}-#{empresa}"
             url = nil
             expire_fragment "emp-json-#{bazar}-#{empresa}"
            else
              logger.debug "json empresa2 ------->"+empre.inspect

              if (!empre['logo'].nil?)
                logger.debug "json empresa3 ------->#{empre['logo']}"
                cluster = Cluster.find(bazar)
                url = "#{cluster.url}/"+empre['logo']
              else 
                url = nil
              end 
            end
         else 
           url = nil
         end 

       end


       url
     end


  
   def helper_formatea(texto)

     texto.gsub(/\n/,'<br/>').html_safe
     
   end
   
   def datos_empresa_remota (bazar, empresa)
                 
     res = Rails.cache.fetch("emp-json-#{bazar}-#{empresa}", :expires_in => 8.hours) do
       logger.debug "----> no estaba cacheado emp-json-#{bazar}-#{empresa}"
       res = dohttpget(bazar, "/api/infoempresa.json/#{empresa}")
     end
       
     if (res.length > 1)
       begin
         empre = JSON.parse(res)
       rescue 
         
         logger.debug "OJO ---> No es parseable este json: #{res} de emp-json-#{bazar}-#{empresa}"
         empre = nil
         expire_fragment "emp-json-#{bazar}-#{empresa}"
       else
          logger.debug "json empresa2 ------->"+empre.inspect
        end
     else 
       empre = nil
     end 
     
     empre
      
   end 
   
   def datos_oferta_remota (bazar, oferta)
                 
     res = Rails.cache.fetch("ofe-json-#{bazar}-#{oferta}", :expires_in => 8.hours) do
       logger.debug "----> no estaba cacheado ofe-json-#{bazar}-#{oferta}"
       res = dohttpget(bazar, "/api/infooferta.json/#{oferta}")
     end
       
     if (res.length > 1)
       begin
         ofe = JSON.parse(res)
       rescue 
         
         logger.debug "OJO ---> No es parseable este json: #{res} de ofe-json-#{bazar}-#{oferta}"
         ofe = nil
         expire_fragment "ofe-json-#{bazar}-#{oferta}"
       else
          logger.debug "json empresa2 ------->"+ofe.inspect
        end
     else 
       ofe = nil
     end 
     
     ofe
      
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
         logger.debug "dohttpget -------------> "+response.inspect
         case response.curl_return_code
         when 0
           if response.code == 404 
             return "404"
           else 
             return response.body
           end 
         else
           logger.debug "ERROR en la petición ---------->"+response.inspect
           return ""
         end
         
      end
      
      hydra.queue r
      hydra.run

    end 
        
end

