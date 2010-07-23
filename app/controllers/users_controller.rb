class UsersController < ApplicationController
  before_filter :require_user ,:except => [:express]

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Account registered!"
      redirect_to  categories_path
    else
      render :action => :new
    end
  end

  def show
    @user = @current_user
  end

  def edit
    @user = @current_user
  end

  def update
    @user = @current_user # makes our views "cleaner" and more consistent
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to account_url
    else
      render :action => :edit
    end
  end

   def express
     unless params[:points].blank?
       session[:points] = params[:points] # store the value in session
      
       paypal = Setting.find_by_name("paypal_fee").value.to_f # paypal % value
       process = Setting.find_by_name("processing_fee").value.to_f # processing fees in cents
       little = Setting.find_by_name("little_surprizes_fee").value.to_f # little_surprizes_fee in cents
      
      

       paypal_fee =  ((paypal * params[:points].to_f) / 100.0).to_f
       points = params[:points].to_f + paypal_fee + (process/ 100.0) + (little/ 100.0) # add all
      

       response = EXPRESS_GATEWAY.setup_purchase((points * 100.0 ),
                    :ip                => request.remote_ip,
                    :return_url        => "#{FACEBOOK_URL}users/#{params[:user_id]}/orders/new?wish_list_id=#{params[:wish_list_id]}",
                    :cancel_return_url =>  "#{FACEBOOK_URL}users/#{params[:user_id]}/wish_lists/#{params[:wish_list_id]}"
          )
         redirect_to EXPRESS_GATEWAY.redirect_url_for(response.token)
     else
       flash[:notice] = "Please fill some points"
       redirect_to "/users/#{params[:user_id]}/wish_lists/#{params[:wish_list_id]}"
     end
   end

end

