class AddFieldToOrders < ActiveRecord::Migration
   def self.up
     add_column :orders ,:wish_list_id ,:integer
    end

  def self.down
  end
end
