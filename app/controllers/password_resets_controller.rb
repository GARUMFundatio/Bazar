
class PasswordResetsController < ApplicationController
  before_filter :load_user_using_perishable_token, :only => [ :edit, :update ]
  before_filter :require_no_user
  
  layout "bazar"
  theme "bazar"
  
  def new
    render :layout => false
  end

  def create
    @user = User.find_by_email(params[:email])
    if @user
      Notifier.password_reset_instructions(@user, Cluster.find(BZ_param("BazarId")).url.gsub("http://","")).deliver
      flash[:notice] = "Se han enviado instrucciones a tu dirección de correo"
      redirect_to "/"
    else
      flash[:error] = "Esta dirección no se corresponde con ningún usuario: #{params[:email]}"
      render :action => :new
    end
  end

  def edit
    logger.debug "entro edit"
    render
  end

  def show
  end

  def update
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
   
    if @user.save
      # logger.debug "actualizada la clave #{params.inspect} #{@user.inspect}"
      flash[:success] = "Tu contraseña se ha actualizado correctamente"
      redirect_to "/home"
    else
      render :action => :edit
    end
  end


  private

  def load_user_using_perishable_token
    logger.debug "entro load_user_using_perishable_token"
    @user = User.find_by_perishable_token(params[:id])
    unless @user
      logger.debug "no encuentro bazar #{params[:id]}"
      flash[:error] = "Lo siento, no encuentro tu cuenta en bazar"
      redirect_to root_url
    end
    logger.debug "salgo load_user_using_perishable_token"
    
  end
end