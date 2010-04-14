class CategoriesController < ApplicationController
ensure_authenticated_to_facebook  

  def index
   @wish_list = WishList.find(params[:wish_list_id])
   @categories = @wish_list.categories
   @category = Category.find(params[:category_id]) rescue nil
   @wishlist_items = CategoryWishList.find(:all, :conditions => { :wish_list_id => params[:wish_list_id] }).map{|c| c.category_id} rescue nil
   @parent = Category.find_all_by_parent_id(nil)
                   
   if !params[:category_id].blank?
                  
      @links = [Category.find(params[:category_id])]             
      @fb_categories = Category.find_all_by_parent_id(params[:category_id])
      sub_categories = Category.find_all_by_parent_id(params[:category_id])
      if sub_categories.blank?
         redirect_to  category_path(params[:category_id])
      end
   else
     @fb_categories = Category.find_all_by_parent_id(nil)
   end
    @category_ids = []
    @category_ids = @wish_list.categories.collect { | h|  h.id } unless @wish_list.nil?
                   
    
     
     
     respond_to do |format|
       format.html {#@banners = Banner.find(:all)
                    #@wish_list = current_user.wish_list unless current_user.nil?
                    #unless @wish_list.blank?
                       #@items = @wish_list.categories(:order => 'desc created_at')
                    #end
                   }
       format.js {  render :update do |page|
                       page.replace_html 'category-list', :partial => 'list'
                    end
                  }
             
     end
   end


   def edit
    @wish_list = WishList.find(params[:wish_list_id])
    @categories = @wish_list.categories
    @wishlist_items = @wish_list.categories.map{|c| c.category_id}
   end


  def show
    @category = Category.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @category }
      format.fbml {ensure_authenticated_to_facebook 
                    @current_user = user rescue nil
                    @wish_list = @current_user.wish_list unless @current_user.nil?
                    #@category = Category.find(params[:category_id]) rescue nil
                     if !params[:id].blank?
                         
                           @ancestors = []                          
                                
                           @array_of_ancestors = @category.ancestors.collect { | h|  h.name } unless @category.nil?          
                           @reversed_ancestors = @array_of_ancestors.reverse
                                                                             
                           @ancestors += @reversed_ancestors
                        
                           @ancestors << @category.name if @category
                                              
                           @fb_categories = Category.find_all_by_parent_id(params[:id])
                      
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
