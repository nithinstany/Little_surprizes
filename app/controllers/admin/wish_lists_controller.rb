class Admin::WishListsController < ApplicationController
  before_filter :check_admin
  layout 'admin'
  def index
    
    @wish_lists = WishList.find(:all,:order => 'date ASC',:conditions =>['points > ?' ,0])
  
    end
end

