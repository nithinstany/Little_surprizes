class AddTransactionIdToOrder < ActiveRecord::Migration
  def self.up
    add_column :orders, :paypal_payer_id, :string
    add_column :orders, :transaction_id, :string
    add_column :orders, :status, :string
    add_column :orders, :name, :string
    add_column :orders, :email, :string
  #  remove_column :orders, :express_token
   # remove_column :orders, :express_payer_id
  end

  def self.down
  end
end
