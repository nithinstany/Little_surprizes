class HomeController < ApplicationController
   def index
     
     @search = Category.new_search(:limit => 4)
     if params[:id]
       @category =  Category.find(params[:id]) 
       if @category.parent_id
         @search.conditions.id = params[:id] 
       else 
         @search.conditions.id = params[:id] 
         @search.conditions.parent_id = nil
       end
     else
       @search.conditions.parent_id = nil
     end
     @categories =  @search.all
     @parent = Category.find_all_by_parent_id(nil,:limit => 4)
     
     respond_to do |format|
       format.html {@banners = Banner.find(:all)
                    @wish_list = current_user.wish_list unless current_user.nil?
                    unless @wish_list.blank?
                       @items = @wish_list.categories(:order => 'desc created_at')
                    end
                   }
       format.js {  render :update do |page|
                       page.replace_html 'category-list', :partial => 'list'
                    end
                  }
       format.fbml{ ensure_authenticated_to_facebook 
                    @current_user = user rescue nil
                    @wish_list = @current_user.wish_list unless @current_user.nil?
                    

                    if !params[:category_id].blank?
                      @fb_categories = Category.find_all_by_parent_id(params[:category_id])
                    else
                      @fb_categories = Category.find_all_by_parent_id(nil)
                    end
                    @category_ids = []
                     @category_ids = @wish_list.categories.collect { | h|  h.id } unless @wish_list.nil?
                   }
     end
  end

  private
    def set_current_user
      set_facebook_session
      #if the session isn't secured, we don't have a good user id
      if facebook_session and facebook_session.secured? and !request_is_facebook_tab?
        User.for(facebook_session.user.to_i,facebook_session) 
      end
    end


    def user
      unless facebook_session.blank?
        User.find_or_create_by_facebook_id(facebook_session.user.to_i) rescue nil?
      #else
        #current_user
      end
    end

end
