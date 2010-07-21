class UserSessionsController < ApplicationController
  layout 'admin'
  before_filter :require_user, :only => :destroy

  def new
    @user_session = UserSession.new
  end


  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
flash[:notice] = "Login successful!"
      if current_user.has_role?(:admin)
        redirect_to  admin_categories_path
      else
        
          redirect_to  "http://apps.facebook.com/testlittlesurpize/"
        
      end
    else
      render :action => :new
    end
  end

  def log_out
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_to login_url
  end


  def destroy
    clear_facebook_session_information
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_to root_url
  end

end

