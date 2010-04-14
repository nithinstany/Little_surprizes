class AddUserIdToWhishList < ActiveRecord::Migration
  def self.up
    add_column :wish_lists, :user_id, :integer
  end

  def self.down
    remove_column :wish_lists, :user_id
  end
end
