class AddFacebookFieldsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :name, :string
    #add_column :users, :facebook_id, :bigint
    #add_column :users, :session_key, :string
  end

  def self.down
    #remove_column :users, :session_key
    #remove_column :users, :facebook_id
    remove_column :users, :name
  end
end
