class Admin::PointsController < ApplicationController
  layout 'admin'
  before_filter :check_admin

  def index
    @user = User.find(params[:user_id])
     fb_session = Facebooker::Session.new('d7069c71e7b928287fccf3c74f67beec', '4c425b88e6730e941276904269779024') # api key and secret
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

