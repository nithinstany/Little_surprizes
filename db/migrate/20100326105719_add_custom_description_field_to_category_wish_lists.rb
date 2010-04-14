class AddCustomDescriptionFieldToCategoryWishLists < ActiveRecord::Migration
  def self.up
    add_column :category_wish_lists, :custom_description, :text
  end

  def self.down
    remove_column :category_wish_lists, :custom_description
  end
end
