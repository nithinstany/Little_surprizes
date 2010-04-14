class UserSessionsController < ApplicationController

  before_filter :require_user, :only => :destroy
  
  def new
    @user_session = UserSession.new
  end
  

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      if current_user.has_role?(:admin)
        redirect_to  admin_categories_path   
      else
        if current_user.wish_list.blank?
          redirect_to  root_url
          
        else
          flash[:notice] = "Login successful!"
          redirect_to  root_url
        end
      end
    else
      render :action => :new
    end
  end


  def destroy
    clear_facebook_session_information
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_to root_url
  end

end
