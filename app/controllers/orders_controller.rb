class OrdersController < ApplicationController
  ensure_authenticated_to_facebook
  before_filter :set_current_user
  before_filter :find_reciver_user
 # require 'mechanize'

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
    @order = Order.find_by_transaction_id(params[:tx])
    @order = @order.blank?? Order.new : @order
    @order.transaction_id = params[:tx]
    @order.payer_id = user.id
    @order.reciver_id = @reciver_user.id
    @order.ip_address = request.remote_ip
    @order.wish_list_id = params[:wish_list_id] 
    @wish_list = WishList.find(@order.wish_list_id)
    #We got the transaction id. Now checking the status of the transaction by posting it to PDT.
    resp = pdt_post(params[:tx])
    if resp.body =~ /SUCCESS/
      split_response(resp.body)
      @order.status = 'success'
      if @order.new_record?
        @order.save
        @reciver_user.points = (@reciver_user.points.to_f + @order.amount.to_f)
        @reciver_user.save_with_validation(false)
        @wish_list.points = (@wish_list.points.to_f + @order.amount.to_f)
        @wish_list.save
      end  
    else
      @order.status = 'failure'
      @order.save
    end
  end


  def edit
    @order = Order.find(params[:id])
  end


  def create
    flash[:notice] = "Thank you for your
contribution. Your friend will soon receive a surprise gift on your
behalf" 
    redirect_to "/users/#{@reciver_user.id}/wish_lists/#{params[:wish_list_id]}"
  end

  def update
    flash[:notice] = "Thank you for your
contribution. Your friend will soon receive a surprise gift on your
behalf" 
    redirect_to "/users/#{@reciver_user.id}/wish_lists/#{params[:wish_list_id]}"
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

  def pdt_post(tx_value) 
    Mechanize.new.post("https://www.paypal.com/cgi-bin/webscr", 'cmd' => '_notify-synch', 'tx'=> tx_value, 'at' => '80iLkMRyEQQhlY2VMkOf9bd3FjpBpAFWvZruB2pedslDYziPPa0fjO3gIgi')
  end

  def split_response(str_resp)
    @order.paypal_payer_id = str_resp.split('payer_id=')[1].split(' ').first
    first_name = str_resp.split('first_name=')[1].split(' ').first
    last_name =  str_resp.split('last_name=')[1].split(' ').first
    @order.name = "#{first_name} #{last_name}"
    @order.email = str_resp.split('payer_email=')[1].split(' ').first.gsub(/%40/, '@')
    @order.processing_fee = str_resp.split('payment_fee=')[1].split(' ').first 
    @order.little_surprizes_fee = Setting.find_by_name("little_surprizes_fee").value.to_f
    @order.street = str_resp.split('address_street=')[1].split(' ').first.split('+').join(' ')
    @order.city = str_resp.split('address_city=')[1].split(' ').first.split('+').join(' ')
    @order.state = str_resp.split('address_state=')[1].split(' ').first
    @order.country = str_resp.split('address_country=')[1].split(' ').first.split('+').join(' ')
    @order.postal_code = str_resp.split('address_zip=')[1].split(' ').first
    ammount = str_resp.split('payment_gross=')[1].split(' ').first.to_f - @order.processing_fee.to_f - @order.little_surprizes_fee.to_f
    @order.amount = ammount.to_f
    
  end
end

