class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user_session, :current_user, :current_user_is_admin, :current_user_is_dinamizador, :current_user_is_invitado, :BZ_param

  def BZ_param(clave)
    conf = Conf.find_by_nombre(clave)
    return conf.valor || nil   
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
      logger.debug "preguntando por quien es el current user: #{@current_user.inspect}"
      return @current_user if defined?(@current_user)
      logger.debug "No parece que este definido resetamos @current_user"
      @current_user = current_user_session && current_user_session.user
      logger.debug "ahora es current user: #{@current_user.inspect}"

      return @current_user if defined?(@current_user)
    end

    def current_user_is_admin
      logger.debug "ApplicationController::current_user_is_Admin"
      if (!current_user.nil?)
        user = User.find_by_login(current_user.login)
        user.roles.each do |r|
          if r[:rol] == 'admin'
            return true
          end 
        end
      end   
      return false
    end

    def current_user_is_dinamizador
      logger.debug "ApplicationController::current_user_is_dinamizador"
      if (!current_user.nil?)
        user = User.find_by_login(current_user.login)
        user.roles.each do |r|
          if r[:rol] == 'dinamizador'
            return true
          end 
        end
      end   
      return false
    end


    def current_user_is_invitado
      logger.debug "ApplicationController::current_user_is_invitado"
      if (!current_user.nil?)
        user = User.find_by_login(current_user.login)
        user.roles.each do |r|
          if r[:rol] == 'invitado'
            return true
          end 
        end
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
  
end

