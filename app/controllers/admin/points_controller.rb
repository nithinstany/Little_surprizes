class Admin::PointsController < ApplicationController
  layout 'admin'
  before_filter :check_admin

  def index
    @user = User.find(params[:user_id])
      fb_session = Facebooker::Session.new('160ff3da7db8f04a75fe58ca5ab90d11', 'def046826bbe6f68b1befa7f4eab9007')  # api key and secret
   begin
      fb_session.secure_with!(@user.session_key, @user.facebook_id, 2.hour.from_now)
      @fb_user = Facebooker::User.new(@user.facebook_id, fb_session)
       
      rescue Facebooker::Session::SessionExpired
  end
  end
  def show
    @user = User.find(params[:user_id])
    @gift = Gift.find(params[:id])
    @orders = Order.find(:all,:conditions => ['wish_list_id =?',@gift.wish_list_id])
  end

end

