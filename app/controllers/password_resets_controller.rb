
class PasswordResetsController < ApplicationController
  before_filter :load_user_using_perishable_token, :only => [ :edit, :update ]
  before_filter :require_no_user

  def new
    render :layout => false 
  end

  def create
    @user = User.find_by_email(params[:email])
    if @user
      @user.deliver_password_reset_instructions!
      flash[:notice] = "Se han enviado instrucciones a tu dirección de correo"
      redirect_to "/"
    else
      flash[:error] = "Esta dirección no se corresponde con ningún usuario: #{params[:email]}"
      render :action => :new
    end
  end

  def edit
  end

  def show
  end

  def update
    @user.password = params[:password]
    # Only if your are using password confirmation
    # @user.password_confirmation = params[:password]
    if @user.save
      flash[:success] = "Tu contraseña se ha actualizado correctamente"
      redirect_to @user
    else
      render :action => :edit
    end
  end


  private

  def load_user_using_perishable_token
    @user = User.find_using_perishable_token(params[:id])
    unless @user
      flash[:error] = "Lo siento, no encuentro tu cuenta."
      redirect_to root_url
    end
  end
end