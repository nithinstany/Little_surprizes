class WishListItemsController < ApplicationController
  def edit
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

end
