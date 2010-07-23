class AddFieldToOrder < ActiveRecord::Migration
  def self.up
    add_column :orders ,:transaction_charge , :decimal, :precision => 8, :scale => 2
  end

  def self.down
  end
end
