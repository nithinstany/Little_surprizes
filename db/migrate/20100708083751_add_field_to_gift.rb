class AddFieldToGift < ActiveRecord::Migration
  def self.up
  add_column :gifts ,:recepient_message , :text
  add_column :gifts ,:donors_message , :text
  end

  def self.down
  end
end
