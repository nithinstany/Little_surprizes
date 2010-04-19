ActionController::Routing::Routes.draw do |map|




  #map.resources :wish_lists, :collection => {:add_to_wishlist => :get, :remove_category => :any , :category_list => :any}, :member => {:publish_to_friends => :any}


  map.resource :account, :controller => "users"
  map.resources :users
  map.resource :user_session, :member => {:logout => :get}
  map.resource :wish_list_item, :member => {:edit => :get}
  map.resource :admin,      :member => {:user_list => :get,:index => :get}
  #map.resource :home,       :member => {:index => :get}
  #map.resources :user_sessions
  #map.resources :users

  map.login "login", :controller => "user_sessions", :action => "new"
  map.logout "logout", :controller => "user_sessions", :action => "destroy"

   map.namespace(:admin) do |admin|
    admin.resources :users, :controller => 'users'
    admin.resources :categories , :controller => 'categories',:collection => {:subcategory_new => :get}
    admin.resources :banners
   end

  #map.resources :categories
  map.root :controller => "wish_lists", :action => "index"

  map.resources :users do |user|
    user.resources :wish_lists
  end
  map.resources :wish_lists,:collection => {:add_to_wishlist => :get, :remove_category => :any , :category_list => :any,:update_wishlist => :any,:grant_permission => :get }, :member => {:publish_to_friends => :any} do |wish_lists|
     wish_lists.resources :categories
  end



end

