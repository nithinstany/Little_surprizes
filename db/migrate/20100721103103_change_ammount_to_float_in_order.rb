class ChangeAmmountToFloatInOrder < ActiveRecord::Migration
  def self.up
    change_column :orders, :amount,:decimal, :precision => 8, :scale => 2
  end

  def self.down
  end
end
