class CreateEmails < ActiveRecord::Migration
  def self.up
    create_table :emails do |t|
      t.string :reference_string
      t.string :subject
      t.text :body

      t.timestamps
    end
  end

  def self.down
    drop_table :emails
  end
end
