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
    @wish_list = WishList.find(params[:wish_list_id])
    @orders = Order.find(:all,:conditions => ['wish_list_id =?',@wish_list.id])
  end


  def edit
    @gift = Gift.find(params[:id])
  end


  def create
    @gift = Gift.new(params[:gift])
    @gift.points = params[:"#{params[:gift][:category_id]}"][:points] unless params[:gift][:category_id].blank?
    
    if @gift.save 
      @wish_list = WishList.find(params[:gift][:wish_list_id])
      @wish_list.points = @wish_list.points.to_f - @gift.points.to_f
      @wish_list.save 
      value = (@user.points.to_f - @gift.points.to_f)
      @user.points = value.to_f
      @user.save_with_validation(false)
      #Notifier.deliver_send_recepient_mail(@gift)

  fb_session = Facebooker::Session.new('160ff3da7db8f04a75fe58ca5ab90d11', 'def046826bbe6f68b1befa7f4eab9007')  # api key and secret
  @user_new = User.find(24)
    begin
      fb_session.secure_with!(@user_new.session_key, @user_new.facebook_id, 2.hour.from_now)
      fb_user = Facebooker::User.new(@user_new.facebook_id, fb_session)
      FacebookPublisher.deliver_recepient_email(@user,fb_user,@gift)
      @wish_list.orders.each do|order|
       donor_user = User.find(order.payer_id)
       FacebookPublisher.deliver_donor_email(donor_user,fb_user,@gift)
         end
        rescue Facebooker::Session::SessionExpired
    end
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

