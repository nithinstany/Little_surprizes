class Category < ActiveRecord::Base

  validates_presence_of :name

  has_many :category_wish_lists
  has_many :wish_lists,:through => :category_wish_lists

  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "135x135>" }
  acts_as_tree :order => "name"



  def self.find_parent(category)
    category = Category.find_by_parent_id(category.parent_id) rescue nil
    return  category
  end
end

