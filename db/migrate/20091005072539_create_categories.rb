class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.string :name
      t.text :description
      t.string :image
      t.string :url
      t.string :lowest_number_of_points_needed
      t.string :avatar_file_name
      t.string :avatar_content_type
      t.integer :avatar_file_size
      t.datetime :avatar_updated_at
      t.integer :parent_id

      t.timestamps
    end
  end

  def self.down
    drop_table :categories
  end
end
