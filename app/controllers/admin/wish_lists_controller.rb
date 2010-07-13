class Admin::WishListsController < ApplicationController
  before_filter :check_admin
  layout 'admin'
  def index
    
    @wish_lists = WishList.find(:all,:order => 'date ASC',:conditions =>['points > ?' ,0])
  
    #@wish_list = WishList.find(params[:wish_list_id],:include => [:category_wish_lists, :categories ])

    #render :update do |page|
     # page.replace_html 'wish_list_replace', :partial => 'wish_list'
    #end
  end

end

