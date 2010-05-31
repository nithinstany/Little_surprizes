class Admin::GiftsController < ApplicationController
  layout 'admin'
  before_filter :find_user
  def index
    @gifts = @user.gifts.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @gifts }
    end
  end

  # GET /gifts/1
  # GET /gifts/1.xml
  def show
    @gift = Gift.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @gift }
    end
  end

  # GET /gifts/new
  # GET /gifts/new.xml
  def new
    @gift = Gift.new


    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @gift }
    end
  end

  # GET /gifts/1/edit
  def edit
    @gift = Gift.find(params[:id])
  end

  # POST /gifts
  # POST /gifts.xml
  def create

   @gift = Gift.new(params[:gift])

    respond_to do |format|
      if @gift.save
        @catogery = Category.find(params[:gift][:category_id])
        @gift.update_attributes(:points => @catogery.lowest_number_of_points_needed)
        value = (@user.points.to_i - @catogery.lowest_number_of_points_needed.to_i)
        @user.points = value.to_f
        @user.save_with_validation(false)
        flash[:notice] = 'Gift was successfully created. '
        format.html { redirect_to( admin_user_points_path(@user.id) ) }
        format.xml  { render :xml => @gift, :status => :created, :location => @gift }
      else
        @wish_list = @user.wish_lists.find(params[:gift][:wish_list_id])
        format.html { render :action => "new" }
        format.xml  { render :xml => @gift.errors, :status => :unprocessable_entity }
      end
    end
  end


  def update
    @gift = Gift.find(params[:id])

    respond_to do |format|
      if @gift.update_attributes(params[:gift])
        flash[:notice] = 'Admin::Gift was successfully updated.'
        format.html { redirect_to(@gift) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @gift.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /gifts/1
  # DELETE /gifts/1.xml
  def destroy
    @gift = Gift.find(params[:id])
    @gift.destroy

    respond_to do |format|
      format.html { redirect_to(gifts_url) }
      format.xml  { head :ok }
    end
  end

  private

  def find_user
    @user = User.find(params[:user_id])
  end
end

