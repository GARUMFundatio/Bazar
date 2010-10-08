class GruposconfsController < ApplicationController
  # GET /gruposconfs
  # GET /gruposconfs.xml
  def index
    @gruposconfs = Gruposconf.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @gruposconfs }
    end
  end

  # GET /gruposconfs/1
  # GET /gruposconfs/1.xml
  def show
    @gruposconf = Gruposconf.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @gruposconf }
    end
  end

  # GET /gruposconfs/new
  # GET /gruposconfs/new.xml
  def new
    @gruposconf = Gruposconf.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @gruposconf }
    end
  end

  # GET /gruposconfs/1/edit
  def edit
    @gruposconf = Gruposconf.find(params[:id])
  end

  # POST /gruposconfs
  # POST /gruposconfs.xml
  def create
    @gruposconf = Gruposconf.new(params[:gruposconf])

    respond_to do |format|
      if @gruposconf.save
        format.html { redirect_to(@gruposconf, :notice => 'Gruposconf was successfully created.') }
        format.xml  { render :xml => @gruposconf, :status => :created, :location => @gruposconf }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @gruposconf.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /gruposconfs/1
  # PUT /gruposconfs/1.xml
  def update
    @gruposconf = Gruposconf.find(params[:id])

    respond_to do |format|
      if @gruposconf.update_attributes(params[:gruposconf])
        format.html { redirect_to(@gruposconf, :notice => 'Gruposconf was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @gruposconf.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /gruposconfs/1
  # DELETE /gruposconfs/1.xml
  def destroy
    @gruposconf = Gruposconf.find(params[:id])
    @gruposconf.destroy

    respond_to do |format|
      format.html { redirect_to(gruposconfs_url) }
      format.xml  { head :ok }
    end
  end
end
