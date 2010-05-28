class Admin::WishListsController < ApplicationController

  def index
    @wish_list = WishList.find(params[:wish_list_id],:include => [:category_wish_lists, :categories ])
    @wish_list_categories = @wish_list.category_wish_lists

    render :update do |page|
      page.replace_html 'wish_list_replace', :partial => 'wish_list'
    end
  end

end

