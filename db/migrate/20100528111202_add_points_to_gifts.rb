class AddPointsToGifts < ActiveRecord::Migration
  def self.up
    add_column :gifts ,:points ,:integer
  end

  def self.down
  end
end

