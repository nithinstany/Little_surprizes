class WishListsController < ApplicationController
  ensure_authenticated_to_facebook
  before_filter :set_current_user,:only => [:delete,:edit,:index,:show]
  #before_filter :wish_list_exists,:only => [:new]

   def index
    @from_mail_user = User.find(params[:user_id]) if params[:user_id]  # when user click on mail link
    @facebook_user = facebook_user
    @wish_lists =  WishList.find(:all, :conditions => { :user_id => user.id })
    #WishList.birthday_reminder


   end

  def show
    @wish_list = WishList.find(params[:id],:include => [:categories]) rescue nil
   # unless @wish_list.blank?
    #  @categories = @wish_list.categories.find(:all,:order => 'created_at DESC')
   # end
   # @current_user = user rescue nil
  end

  def new
    @user = facebook_user
    @wish_list = WishList.new
    @current_user = user rescue nil
  end


  def edit
    @wish_list = WishList.find(params[:id],:include =>[:categories, :category_wish_lists])
    @current_user = user
    @wishlist_items = @wish_list.category_ids rescue nil
    @parent = Category.find_all_by_parent_id(nil)
=begin
    Category.find(:all,:select => 'id').each do |category|
       unless CategoryWishList.find_by_wish_list_id_and_category_id(@wish_list.id, category.id) # written in  FieldValue model
          category_wish_list  = @wish_list.category_wish_lists.build
          category_wish_list.category_id = category.id
       end
    end
=end
     respond_to do |format|
       format.html {
                   }
       format.js {  render :update do |page|
                       page.replace_html 'category-list', :partial => 'list'
                    end
                  }

     end

  end

  def create
    @facebook_user = facebook_user
    @wish_list = WishList.new(params[:wish_list])
    @wish_list.user = user

    if @wish_list.save
      flash[:notice] = "Wish list has been created successfully."
      facebook_permissions(@facebook_user) ?  (redirect_to(wish_lists_path)) : (  redirect_to(grant_permission_wish_lists_path) )

    else
      flash[:error] = "Make sure that all required fields are entered."
      @wish_list = nil
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
          flash[:notice] = 'Wish list was successfully updated  and Published to Facebook'
          @user = facebook_user
           if @user.has_permissions?('publish_stream')
             @user.publish_to(@user, :message => 'has added new product categories to wishlist.',
                :action_links => [:text => "visit wishlist",:href => "http://apps.facebook.com/littlesurprizes/users/#{user.id}/wish_lists"],

                 :attachment =>  { :name => "#{@wish_list.name}",
                         :description => "#{@wish_list.description}",
                         :media => [{ :type => 'image',
                                      :src => "#{SITE_URL}images/facebook_publish.jpg",
                                      :href => "http://apps.facebook.com/littlesurprizes"
                                    }]
                       }
      )
             redirect_to(wish_lists_path)
          else
            flash[:notice] = "You Don't a have permissions to publish on wall, Please click on grant permissions Button ."
            @facebook_user = facebook_user
            #@test = "/wish_lists/#{@wish_list.id}/edit"
           redirect_to grant_permission_wish_lists_path
          end
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
    redirect_to(wish_lists_path)
  end

  def add_to_wishlist
    @wish_list = user.wish_list
    category = Category.find(params[:category_id])

    unless @wish_list.blank?
      @wish_list.categories << category
      redirect_to(wish_list_path(@wish_list))
    else
      flash[:notice] = 'Please create wish list first.'
      redirect_to(new_wish_list_path)
    end
  end

  def publish

    @wish_list = WishList.find(params[:id])
    @user = facebook_user
    if @user.has_permissions?('publish_stream')
      @user.publish_to(@user, :message => 'has added new product categories to wishlist.',
       :action_links => [:text => "visit wishlist",:href => "http://apps.facebook.com/littlesurprizes/users/#{user.id}/wish_lists"],

       :attachment =>  { :name => "#{@wish_list.name}",
                         :description => "#{@wish_list.description}",
                         :media => [{ :type => 'image',
                                      :src => "#{SITE_URL}images/facebook_publish.jpg",
                                      :href => "http://apps.facebook.com/littlesurprizes"
                                    }]
                       }
      )
      flash[:notice] = "Published to Facebook"
      redirect_to(wish_lists_path)
    else
      @facebook_user = facebook_user
      flash[:notice] = "You Don't a have permissions to publish on wall, Please click on grant permissions Button ."
     # redirect_to grant_permission_wish_lists_path
      # @test = "/wish_lists"
       redirect_to grant_permission_wish_lists_path
    end
  end


  def grant_permission

    @facebook_user = facebook_user
    if facebook_permissions(facebook_user)
      flash[:notice] = "Facebook Permissions are set."
      redirect_to wish_lists_path
    else
    end
  end

  def remove_category
    @wish_list =  user.wish_list
    @wish_list.categories.delete(Category.find(params[:id]))
    redirect_to(wish_list_path(@wish_list))
  end

  def category_list
  @categories = Category.all
  end


  def update_wishlist
   wish_list = WishList.find(params[:wish_list])
   @wishlist_items = CategoryWishList.find(:all, :conditions => { :wish_list_id => params[:wish_list] }) rescue nil
     categories = Category.find(params[:categories])
   if @wishlist_items
     @wishlist_items.each do |wish_list_item|
       wish_list_item.destroy
     end
   end

   categories.each do |category|
     categories_wishlist = CategoryWishList.find_or_create_by_wish_list_id_and_category_id(wish_list,category)
     categories_wishlist.wish_list_id = wish_list.id
     categories_wishlist.category_id = category.id
     categories_wishlist.custom_description = "desc"
     categories_wishlist.save
    end
     redirect_to (wish_list_categories_path(wish_list))
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

   def user
    user = User.find_by_facebook_id(facebook_session.user.to_i)
    user ||= set_current_user
   end

  def facebook_user
    facebook_session.user
  end

  def wish_list_exists
      if !user.wish_list.nil?
        flash[:notice] = "You can have only one wish list"
        redirect_to root_url
       end
  end




  def facebook_permissions(facebook_user)
     permissions = ["offline_access","publish_stream",'email'] #"", "share_item","status_update", , "read_stream"
     for per in permissions
        value = facebook_user.has_permissions?("#{per}")
        return false if !value
     end
     return true
  end


end

