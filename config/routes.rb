ActionController::Routing::Routes.draw do |map|


 # map.resources :orders


  #map.resources :wish_lists, :collection => {:add_to_wishlist => :get, :remove_category => :any , :category_list => :any}, :member => {:publish_to_friends => :any}


  map.resource :account, :controller => "users"
  map.resources :users ,:member => {  :express => :post } ,:has_many => [:orders]
  map.resource :user_session, :member => {:logout => :get}
  map.resource :wish_list_item, :member => {:edit => :get}


  map.login "login", :controller => "user_sessions", :action => "new"
  map.logout "logout", :controller => "user_sessions", :action => "destroy"
  map.log_out "log_out", :controller => "user_sessions", :action => "log_out"

   map.namespace(:admin) do |admin|
    admin.root :controller => 'categories', :action => 'index'
    admin.resources :users, :controller => 'users' do |user|
      user.resources :points
      user.resources :gifts
    end
    admin.resources :categories , :controller => 'categories',:collection => {:subcategory_new => :get}
    admin.resources :banners

   end

  #map.resources :categories
  map.root :controller => "wish_lists", :action => "index"

  map.resources :users do |user|
    user.resources :wish_lists
  end
  map.resources :wish_lists,:collection => {:add_to_wishlist => :get, :remove_category => :any , :category_list => :any,:update_wishlist => :any,:grant_permission => :get }, :member => {:publish => :any } do |wish_lists|
     wish_lists.resources :categories
  end



end

