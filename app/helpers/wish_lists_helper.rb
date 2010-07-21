module WishListsHelper

  def check_user
    @from_mail_user.facebook_id.to_s == @facebook_user.facebook_id.to_s ? false : true
  end
  
  def friends_list
    array = [ ]
    @friend_list.each do |flists|
      array << [ ]
    end
  end
  
  def category_id_include_in_params(category_id)
    return false if (@params.blank? || !@params[:categories].include?(category_id.to_s))
    return true 
  end
  
  def get_value_from_params(category_id)
    return '' if @params.blank?
    return @params["category_#{category_id}_custom_description"]
  end
  
  def category_id_include_in_params_edit(category_id)
    return true if (@wish_list.category_ids.include?(category_id) && @params.blank?)
    return true if !@params.blank? && @params[:categories].include?(category_id.to_s)
    return false
  end
  
  def get_value_from_params_edit(category_id)
    if  @wish_list.category_ids.include?(category_id) && @params.blank?
      record = CategoryWishList.find_by_wish_list_id_and_category_id(@wish_list.id, category_id)
      return record.blank?? "" : record.custom_description
    end
    unless @params.blank? 
      return @params["category_#{category_id}_custom_description"]
    end
    return ''    
    
  end
    
  
end

