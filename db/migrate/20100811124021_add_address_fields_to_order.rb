class AddAddressFieldsToOrder < ActiveRecord::Migration
  def self.up
    add_column :orders, :street, :string
    add_column :orders, :city, :string
    add_column :orders, :state, :string
    add_column :orders, :country, :string
    add_column :orders, :postal_code, :string
  end

  def self.down
  end
end
