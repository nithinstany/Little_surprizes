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


  def show
    @gift = Gift.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @gift }
    end
  end


  def new
    @gift = Gift.new
  end


  def edit
    @gift = Gift.find(params[:id])
  end


  def create
    @gift = Gift.new(params[:gift])
    @gift.points = params[:"#{params[:gift][:category_id]}"][:points] unless params[:gift][:category_id].blank?
    
    if @gift.save 
      value = (@user.points.to_i - @gift.points.to_i)
      @user.points = value.to_f
      @user.save_with_validation(false)
      flash[:notice] = 'Gift was successfully created. '
      redirect_to( admin_user_points_path(@user.id) )  
    else
      @wish_list = @user.wish_lists.find(params[:gift][:wish_list_id]) unless  params[:gift][:wish_list_id].blank?
      render :action => "new"
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

