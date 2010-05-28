class CreateAdminGifts < ActiveRecord::Migration
  def self.up
    create_table :gifts do |t|
      t.integer :user_id
      t.integer :wish_list_id


      t.timestamps
    end
  end

  def self.down
    drop_table :gifts
  end
end

