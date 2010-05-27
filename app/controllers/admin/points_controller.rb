class Admin::PointsController < ApplicationController
  layout 'admin'
  before_filter :check_admin

  def index
     @users = User.find(:all,:include => [:recived_gifts,:donated_gifts], :conditions => [ 'id != ? ',current_user.id ])
  end

  def show
    @user = User.find(params[:id])
    render :layout => false
  end

end

