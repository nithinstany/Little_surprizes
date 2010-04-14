class AddCustomDescriptionFieldToCategoriesWishLists < ActiveRecord::Migration
  def self.up
    add_column :categories_wish_lists, :custom_description, :text
  end

  def self.down
    remove_column :categories_wish_lists, :custom_description
  end
end
