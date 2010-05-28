class ChangeCloumnInGift < ActiveRecord::Migration
  def self.up
    change_column :gifts, :comments, :text
  end

  def self.down
  end
end

