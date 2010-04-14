# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def admin?
     current_user && current_user.has_role?(:admin)
  end

  def find_category(name)
    category = Category.find_by_name(name) rescue nil
    return  category
  end

  def find_root(id)
    category = Category.find(id) rescue nil
    return  category
  end

  def find_custom_description(wish_list,category)
   description = CategoryWishList.find_by_wish_list_id_and_category_id(wish_list,category).custom_description rescue nil
   return description
  end

  def find_by_wish_list_and_category(w_id,ct_id)
    record = CategoryWishList.find_by_wish_list_id_and_category_id(w_id,ct_id)
    record.blank?? "" : record.custom_description
  end
end

