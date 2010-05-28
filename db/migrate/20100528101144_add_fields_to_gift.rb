class AddFieldsToGift < ActiveRecord::Migration
  def self.up
    add_column :gifts ,:category_id ,:integer
    add_column :gifts ,:comments ,:string
  end

  def self.down
  end
end

