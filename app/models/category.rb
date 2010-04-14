class Category < ActiveRecord::Base
  #belongs_to :wish_list
  #has_and_belongs_to_many :wishlists #,:uniq => true
  has_many :category_wish_lists
  has_many :wish_lists,:through => :category_wish_lists
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "135x135>" }
  acts_as_tree :order => "name"



 def self.find_parent(category)
    category = Category.find_by_parent_id(category.parent_id) rescue nil
    return  category
  end
end

