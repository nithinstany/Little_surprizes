class WishListsController < ApplicationController
  ensure_authenticated_to_facebook
  before_filter :set_current_user,:only => [:delete,:edit,:index,:show]


   def index
    @from_mail_user = User.find(params[:user_id]) if params[:user_id]  # when user click on mail link
    @facebook_user = user
    @friend_lists =  facebook_user.friend_lists rescue nil
   end

  def show
    @from_mail_user = User.find(params[:user_id]) if params[:user_id]
    @wish_list = WishList.find(params[:id]) rescue nil
    @current_user = user rescue nil
    @facebook_user = user
   
  end

  def new
    @user = facebook_user
    @wish_list = WishList.new
    @current_user = user rescue nil
    @parent = Category.find_all_by_parent_id(nil)
  end


  def edit
    @wish_list = WishList.find(params[:id],:include =>[:categories, :category_wish_lists])
    @current_user = user
    @wishlist_items = @wish_list.category_ids rescue nil
    @parent = Category.find_all_by_parent_id(nil)
    respond_to do |format|
       format.html
       format.js {  render :update do |page|
                       page.replace_html 'category-list', :partial => 'list'
                    end
                  }
     end

  end

  def create
    @facebook_user = facebook_user
    @wish_list = WishList.new(params[:wish_list])
    @current_user = user 
    @wish_list.user = @current_user
     
     if params[:categories].blank?
       @parent = Category.find_all_by_parent_id(nil)
       flash[:notice] = "Please select category"
       render :action => "new"
       return nil
    end
    if params[:email] && @wish_list.save
       unless params[:categories].blank?
         params[:categories].each do |category_id|
           CategoryWishList.create({ :category_id => category_id ,:wish_list_id => @wish_list.id , :custom_description => params["category_#{category_id}_custom_description"] })
         end
       end
      @current_user.email = params[:email]
      @current_user.save_with_validation(false)
      flash[:notice] = "Wish list has been created successfully."
      facebook_permissions(@facebook_user) ?  (redirect_to(wish_lists_path)) : (  redirect_to(grant_permission_wish_lists_path) )

    else
       
      flash[:notice] = "Make sure that all required fields are entered."
      @wish_list = nil
      @parent = Category.find_all_by_parent_id(nil)
      render :action => 'new'
    end

  end


  def update
    @wish_list = WishList.find(params[:id])
    if @wish_list.update_attributes(params[:wish_list])
       CategoryWishList.delete_all(["wish_list_id = ?", @wish_list.id]) # delete CategoryWishList all records of wish_list using single step
       unless params[:categories].blank?
         params[:categories].each do |category_id|
           CategoryWishList.create({ :category_id => category_id ,:wish_list_id => @wish_list.id , :custom_description => params["category_#{category_id}_custom_description"] })
         end
       end

       if params[:commit] == "Save and Publish"
          
          @user = facebook_user
           #if @user.has_permissions?('publish_stream')
             @friend_lists =  facebook_user.friend_lists rescue nil
             if @friend_lists
               flash[:notice] = 'Wish list was successfully updated.'
               redirect_to publish_wish_list_path(@wish_list)
             else
               publish_to_facebook(@wish_list, @user.id)
               flash[:notice] = 'Wish list was successfully updated  and Published to Facebook'
               redirect_to(wish_lists_path)
             end
          #else
          #  flash[:notice] = "You Don't a have permissions to publish on wall, Please click on grant permissions Button ."
          #  @facebook_user = facebook_user
            #@test = "/wish_lists/#{@wish_list.id}/edit"
         #  redirect_to grant_permission_wish_lists_path
        #  end
       else
         flash[:notice] = 'Wish list was successfully updated.'
         redirect_to(wish_lists_path)
       end
    else
       render :action => 'edit'
    end
  end


  def destroy
    @wish_list = WishList.find(params[:id])
    @wish_list.destroy
    flash[:notice] = 'Wish list was successfully Deleted.'
    redirect_to(wish_lists_path)
  end

  def publish
    @wish_list = WishList.find(params[:id])
    @user = facebook_user
    @friend_lists =  @user.friend_lists rescue nil

  end
  
  def wish_list_publish
    @wish_list = WishList.find(params[:id])
    @user = facebook_user
   
    if @user.has_permissions?('publish_stream')
      if params[:friend_list]
        for friend_list in params[:friend_list]
          friend_ids = get_friends_friend_list(friend_list)
          friend_ids.each do |friend_facebook_id|
            publish_to_facebook(@wish_list, friend_facebook_id)
          end 
        end
      else
        publish_to_facebook(@wish_list, @user.id)
      end 
      flash[:notice] = "Published to Facebook"
      redirect_to(wish_lists_path)
    else
      store_location
      @facebook_user = facebook_user
      flash[:notice] = "You Don't have a permissions to publish on wall, Please click on grant permissions Button ."
      redirect_to grant_permission_wish_lists_path
    end
    
  end
  

  def grant_permission
    @facebook_user = facebook_user
    if facebook_permissions(facebook_user)
      flash[:notice] = "Facebook Permissions are set."
      redirect_back_or_default(wish_lists_path)
    end
  end



private

  def owner_of_the_profile
    @wish_list = WishList.find(params[:id])
    if @wish_list.user == facebook_session.user.to_i
      return true
    else
      redirect_to(wish_list_path(@wish_list))
      flash[:error] = "you are not authorised to acess this page"
    end
  end
  
  def get_friends_friend_list(flist_id) # this is used get friends facebook id from friend list
    options = {:uid => facebook_user.id, :flid => flist_id }
    facebook_session.post('facebook.friends.get', options, user.session_key)
  end

  def publish_to_facebook(wish_list,target) # this method is used to publish whistlist to facebook
    facebook_session.post('facebook.stream.publish', 
      { :uid => facebook_session.user.id, 
        :target_id => target ,
        :message => "has added new product categories to wishlist '#{wish_list.name}'.",
        :action_links => [ 'text' => "visit wishlist",
                           'href' => "http://apps.facebook.com/littlesurprizes/users/#{user.id}/wish_lists/#{wish_list.id}"
                         ],
          :attachment =>   { 'media' => [ 
                                       { 'type' => 'image',
                                         'src' => "#{SITE_URL}images/facebook_publish.jpg",
                                         'href' => "http://apps.facebook.com/littlesurprizes"
                                       }
                                     ]
                          }.to_json   
       })
  #littlesurprizes

end
  
  
  
   def user
    user = User.find_by_facebook_id(facebook_session.user.to_i)
    user ||= set_current_user
   end

  def facebook_user
    facebook_session.user
  end

  def facebook_permissions(facebook_user)
     permissions = ["offline_access","publish_stream",'email'] 
     facebook_user.has_permissions?(["offline_access","publish_stream",'email'])
    
     #for per in permissions
     #   value = facebook_user.has_permissions?("#{per}")
     #   return false if !value
    # end
    # return true
  end


end

