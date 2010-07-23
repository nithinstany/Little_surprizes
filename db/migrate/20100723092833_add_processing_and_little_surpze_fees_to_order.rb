class AddProcessingAndLittleSurpzeFeesToOrder < ActiveRecord::Migration
  def self.up
    rename_column :orders, :transaction_charge , :paypal_fee
    add_column :orders, :processing_fee, :decimal, :precision => 8, :scale => 2
    add_column :orders, :little_surprizes_fee , :decimal, :precision => 8, :scale => 2
  end

  def self.down
  end
end
