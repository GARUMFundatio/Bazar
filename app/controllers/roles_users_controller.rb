class RolesUsersController < ApplicationController

  def index
    @roles_users = RolesUser.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @roles_users }
    end
  end

  def show
    @roles_user = RolesUser.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @roles_user }
    end
  end

  def new
    @roles_user = RolesUser.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @roles_user }
    end
  end

  def edit
    @roles_user = RolesUser.find(params[:id])
  end

  def create
    @roles_user = RolesUser.new(params[:roles_user])

    respond_to do |format|
      if @roles_user.save
        format.html { redirect_to(@roles_user, :notice => 'Roles user was successfully created.') }
        format.xml  { render :xml => @roles_user, :status => :created, :location => @roles_user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @roles_user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @roles_user = RolesUser.find(params[:id])

    respond_to do |format|
      if @roles_user.update_attributes(params[:roles_user])
        format.html { redirect_to(@roles_user, :notice => 'Roles user was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @roles_user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @roles_user = RolesUser.find(params[:id])
    @roles_user.destroy

    respond_to do |format|
      format.html { redirect_to(roles_users_url) }
      format.xml  { head :ok }
    end
  end
end
