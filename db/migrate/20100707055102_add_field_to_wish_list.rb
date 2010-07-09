class AddFieldToWishList < ActiveRecord::Migration
 def self.up
  add_column :wish_lists ,:points , :decimal, :precision => 8, :scale => 2,:default => 0.0
  end

  def self.down
  end
end
