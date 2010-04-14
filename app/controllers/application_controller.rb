# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all
  helper_method :current_user_session, :current_user, :facebook_session
  filter_parameter_logging :password, :password_confirmation
  
  private
    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end
    
    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.record
    end
    
    def require_user
      unless current_user
        store_location
        flash[:notice] = "You must be logged in to access this page"
        redirect_to new_user_session_url
        return false
      end
    end

    def require_no_user
      if current_user
        store_location
        flash[:notice] = "You must be logged out to access this page"
        redirect_to categories_url
        return false
      end
    end
    
    def store_location
      session[:return_to] = request.request_uri
    end
    
    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end

   def check_logged_in
    if !current_user
      flash[:notice] = "You must be logged in to access this page"
      redirect_to(login_url)
    end
  end
  
  

  def check_admin
    if current_user
      if !current_user.has_role?('admin')
        flash[:notice] = "Only admin can access this page"
        redirect_to(categories_url)
       end
     else
       flash[:notice] = "You must be logged in to access this page"
       redirect_to(login_url)
     end
   
  end

  def logged_in?
   current_user.nil?? false : true
  end

  def admin?
    if  logged_in? && @current_user.has_role?('admin') 
     return true
    else
     return false
    end
  end


 def wishlist(facebook_session)
    set_facebook_session
    @wish_list = WishList.find_by_facebook_id(facebook_session) rescue nil
    return  @wish_list
  end
  
  def find_category(id)
    category = Category.find(id).name
    return  category
  end

 def set_current_user
      set_facebook_session
      #if the session isn't secured, we don't have a good user id
      if facebook_session and facebook_session.secured? and !request_is_facebook_tab?
        User.for(facebook_session.user.to_i,facebook_session) 
      end
    end

def has_role?(role)
    list ||= self.roles.collect(&:name)
    list.include?(role.to_s) || list.include?('admin')
end

end
