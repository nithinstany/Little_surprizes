class OrdersController < ApplicationController
  ensure_authenticated_to_facebook
  before_filter :set_current_user
  before_filter :find_reciver_user


  def index
    @orders = Order.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @orders }
    end
  end

  def show
    @order = Order.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @order }
    end
  end


  def new
    @order = Order.new(:express_token => params[:token])
     @order.wish_list_id = params[:wish_list_id]
    @details = EXPRESS_GATEWAY.details_for(params[:token])
    @confirmed = Order.find_by_express_token(params[:token]) ? true : false

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @order }
    end
  end


  def edit
    @order = Order.find(params[:id])
  end


  def create
    @order = Order.new(params[:order])
    @order.payer_id =  @facebook_user.id
    @order.reciver_id =  @reciver_user.id
    if @order.save && @order.purchase
       @order.transaction_charge = @order.amount - session[:points].to_f
       @order.save 
       @reciver_user.points = (@reciver_user.points.to_f + session[:points].to_f)
       @reciver_user.save_with_validation(false)
       wish_list = WishList.find(@order.wish_list_id)
       wish_list.points = wish_list.points + session[:points].to_f
       wish_list.save
       flash[:notice] = "Successfully gifted $#{@order.amount}"
    else
       flash[:notice] = "Failure: #{@order.transaction.message} "
    end
    redirect_to "/users/#{@reciver_user.id}/wish_lists"
  end

  def update
    @order = Order.find(params[:id])

    respond_to do |format|
      if @order.update_attributes(params[:order])
        flash[:notice] = 'Order was successfully updated.'
        format.html { redirect_to(@order) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @order.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @order = Order.find(params[:id])
    @order.destroy

    respond_to do |format|
      format.html { redirect_to(orders_url) }
      format.xml  { head :ok }
    end
  end

  private

  def find_reciver_user
    @reciver_user = User.find(params[:user_id])
    @facebook_user = user
  end

  def user
    user = User.find_by_facebook_id(facebook_session.user.to_i)
    user ||= set_current_user
  end

end

