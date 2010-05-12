class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.string :ip_address
      t.string :first_name
      t.string :last_name
      t.string :express_token
      t.string :express_payer_id
      t.integer :amount
      t.integer :payer_id
      t.integer :reciver_id
      t.timestamps
    end
  end

  def self.down
    drop_table :orders
  end
end

