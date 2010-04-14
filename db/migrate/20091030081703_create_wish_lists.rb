class CreateWishLists < ActiveRecord::Migration
  def self.up
    create_table :wish_lists do |t|
      t.integer :facebook_id
      t.integer :category_id
      t.string :name
      t.text   :description

      t.timestamps
    end
     execute "alter table wish_lists modify facebook_id bigint"
  end

  def self.down
    drop_table :wish_lists
  end
end
