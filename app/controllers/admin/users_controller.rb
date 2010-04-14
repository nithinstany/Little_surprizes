class Admin::UsersController < ApplicationController
  before_filter :check_admin
  
  def index
    @search = User.new_search(params[:search])
    @users = @search.all
    respond_to do |format|
      format.html # index.html.erb
      format.js {  render :update do |page|
                     page.replace_html 'user-list', :partial => 'list'
                   end
                 }
   end
  end
end
