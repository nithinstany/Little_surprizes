class Admin::SettingsController < ApplicationController
  layout 'admin'
  before_filter :check_logged_in
  before_filter :check_admin
  
  def index
  end

  def create
    redirect = false
    params[:settings].each do | setting|
      if setting[1]['value'].blank?
        redirect = true
      end
    end
    
    if redirect
      flash[:notice] = "Please enter all fields"
    else
      params[:settings].each do |setting|
        Setting.find(setting[0]).update_attribute('value', setting[1]['value'] )
      end
      flash[:notice] = "values are updated."
    end
    redirect_to admin_settings_path
    
    
end

  

end
