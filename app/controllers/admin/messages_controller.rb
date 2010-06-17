class Admin::MessagesController < ApplicationController
  layout 'admin'
  before_filter :find_user
 
  def index
    @messages = Message.all
  end

  def show
    @message = Message.find(params[:id])
  end

  def new
    if @user.email.blank?
      flash[:notice] = 'Selected user email is blank'
      redirect_to :back
    end
    @message = Message.new
    
  end


  def edit
    @message = Message.find(params[:id])
  end

  def create
    @message = Message.new(params[:message])
    puts "pppppppppppppppppppppppppp #{@user.email}"
    respond_to do |format|
      if @message.save
        
        Notifier.deliver_send_mail(@user ,@message)
        
        flash[:notice] = 'Message was successfully created.'
        format.html { redirect_to( admin_users_path  ) }
        format.xml  { render :xml => @message, :status => :created, :location => @message }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @message.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @message = Message.find(params[:id])

    respond_to do |format|
      if @message.update_attributes(params[:message])
        flash[:notice] = 'Message was successfully updated.'
        format.html { redirect_to(@message) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @message.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @message = Message.find(params[:id])
    @message.destroy

    respond_to do |format|
      format.html { redirect_to(messages_url) }
      format.xml  { head :ok }
    end
  end
  


  def find_user
    @user = User.find(params[:user_id])
  end
  
end
