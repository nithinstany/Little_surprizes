class CategoriesWishLists < ActiveRecord::Migration
  def self.up
   create_table :categories_wish_lists, :id => false do |t|
      t.integer :wish_list_id
      t.integer :category_id
      t.timestamps
   end
  end

  def self.down
   drop_table :categories_wish_lists
  end
end
