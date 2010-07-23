class CreateAdminSettings < ActiveRecord::Migration
  def self.up
    create_table :settings do |t|
      t.string :name
      t.decimal :value,  :precision => 8, :scale => 2
      t.timestamps
    end
    
    ['paypal_fee', 'processing_fee', 'little_surprizes_fee'].each do |name|
      Setting.create(:name => name ,:value => 3.00)
    end
  end

  def self.down
    drop_table :settings
  end
end
