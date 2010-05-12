class AddPointsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :points ,:decimal, :precision => 12, :scale => 2 , :default => 0.0
  end

  def self.down
  end
end

