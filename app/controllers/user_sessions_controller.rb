class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy
  
  layout "bazar"
  # theme "bazar"
  
  def new
    @user_session = UserSession.new
    if !current_user.nil?
      redirect_to "/home"
    else
      render :layout => false 
    end
    
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Login successful!"
      # redirect_back_or_default root_url('/home')
      # redirect_to "/home", :format => params[:format]
      render :layout => false
    else
      render :action => :new, :layout => false
    end
  end
  
  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_to "/", :format => params[:format]
  end
  
  
end

