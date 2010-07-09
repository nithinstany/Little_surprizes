class AddFieldToWishLists < ActiveRecord::Migration
  def self.up
    add_column :wish_lists ,:date ,:date
  end

  def self.down
  end
end
