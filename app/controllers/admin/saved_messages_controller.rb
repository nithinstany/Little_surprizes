class Admin::SavedMessagesController < ApplicationController
  before_filter :check_admin
  layout 'admin'
  
  def index
    @saved_messages = SavedMessage.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @saved_messages }
    end
  end

  # GET /saved_messages/1
  # GET /saved_messages/1.xml
  def show
    @saved_message = SavedMessage.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @saved_message }
    end
  end

  # GET /saved_messages/new
  # GET /saved_messages/new.xml
  def new
    @saved_message = SavedMessage.new

  end

  # GET /saved_messages/1/edit
  def edit
    @saved_message = SavedMessage.find(params[:id])
  end

  # POST /saved_messages
  # POST /saved_messages.xml
  def create
    @saved_message = SavedMessage.new(params[:saved_message])

    respond_to do |format|
      if @saved_message.save
        flash[:notice] = 'SavedMessage was successfully created.'
        format.html { redirect_to( edit_admin_saved_message_path( @saved_message)) }
        format.xml  { render :xml => @saved_message, :status => :created, :location => @saved_message }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @saved_message.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /saved_messages/1
  # PUT /saved_messages/1.xml
  def update
    @saved_message = SavedMessage.find(params[:id])

    respond_to do |format|
      if @saved_message.update_attributes(params[:saved_message])
        flash[:notice] = 'SavedMessage was successfully updated.'
        format.html { redirect_to( edit_admin_saved_message_path( @saved_message)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @saved_message.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /saved_messages/1
  # DELETE /saved_messages/1.xml
  def destroy
    @saved_message = SavedMessage.find(params[:id])
    @saved_message.destroy

    respond_to do |format|
      format.html { redirect_to(saved_messages_url) }
      format.xml  { head :ok }
    end
  end
end
