class CreateSavedMessages < ActiveRecord::Migration
  def self.up
    create_table :saved_messages do |t|
      t.string :subject
      t.text :body
      t.timestamps
    end
  end

  def self.down
    drop_table :saved_messages
  end
end
