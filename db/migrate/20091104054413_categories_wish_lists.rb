class CategoriesWishLists < ActiveRecord::Migration
  def self.up
   create_table :category_wish_lists do |t|
      t.integer :wish_list_id
      t.integer :category_id
      t.timestamps
   end
  end

  def self.down
   drop_table :category_wish_lists
  end
end

