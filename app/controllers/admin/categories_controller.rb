class Admin::CategoriesController < ApplicationController
 
before_filter :check_logged_in
before_filter :check_admin,:except => :index
  
  def index
     
     
     @search = Category.new_search(params[:search])
      if !params[:category_id].blank?
       
       @search.conditions.parent_id = params[:category_id] if params[:category_id]
     else
       if params[:id]
          @category =  Category.find(params[:id])
          if @category.parent_id
            @search.conditions.id = params[:id] 
          else 
            @search.conditions.id = params[:id] 
            @search.conditions.parent_id = nil
          end
        else
          @search.conditions.parent_id = nil
        end
     end
     @categories = @search.all
     @parent = Category.find_all_by_parent_id(nil)
     @banners = Banner.find(:all)


     respond_to do |format|
       format.html # index.html.erb
       format.js {  render :update do |page|
                           page.replace_html 'category-list', :partial => 'list'
                       end
                  }
     end
   end

  
  def show
    @category = Category.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @category }
    end
  end

  
  def new
    @category = Category.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @category }
    end
  end

  
  def edit
    @category = Category.find(params[:id])
  end

  
  def create
    @category = Category.new(params[:category])

    respond_to do |format|
      if @category.save
        flash[:notice] = 'Category was successfully created.'
        format.html { redirect_to(admin_categories_path) }
        format.xml  { render :xml => @category, :status => :created, :location => @category }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
      end
    end
  end

 
  def update
    
    @category = Category.find(params[:id])

    respond_to do |format|
      if @category.update_attributes(params[:category])
        flash[:notice] = 'Category was successfully updated.'
        format.html { redirect_to(admin_categories_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
      end
    end
  end

  
  def destroy
    @category = Category.find(params[:id])
    @category.destroy

    respond_to do |format|
      format.html { redirect_to(admin_categories_path) }
      format.xml  { head :ok }
    end
  end


 def subcategory_new
  @category = Category.new
  @parent = Category.find_all_by_parent_id(nil)
 end

 




 

 
  
end
