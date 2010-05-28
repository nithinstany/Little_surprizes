class Admin::PointsController < ApplicationController
  layout 'admin'
  before_filter :check_admin

  def index
    @user = User.find(params[:user_id])
  end


end

