class Admin::BannersController < ApplicationController
   
  #before_filter :check_logged_in
  before_filter :check_admin

  
  def index
    @banners = Banner.all
      
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @banners }
    end

       
                  
     
  end

  
  def show
    @banner = Banner.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @banner }
    end
  end

  
  def new
    @banner = Banner.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @banner }
    end
  end

  
  def edit
    @banner = Banner.find(params[:id])
  end

  
  def create
    @banner = Banner.new(params[:banner])

    respond_to do |format|
      if @banner.save
        flash[:notice] = 'Banner was successfully created.'
        format.html { redirect_to(admin_categories_path) }
        format.xml  { render :xml => @banner, :status => :created, :location => @banner }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @banner.errors, :status => :unprocessable_entity }
      end
    end
  end

  
  def update
    @banner = Banner.find(params[:id])

    respond_to do |format|
      if @banner.update_attributes(params[:banner])
        flash[:notice] = 'Banner was successfully updated.'
        format.html { redirect_to(admin_categories_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @banner.errors, :status => :unprocessable_entity }
      end
    end
  end

  
  def destroy
    @banner = Banner.find(params[:id])
    @banner.destroy

    respond_to do |format|
      format.html { redirect_to(admin_categories_path) }
      format.xml  { head :ok }
    end
  end
end
