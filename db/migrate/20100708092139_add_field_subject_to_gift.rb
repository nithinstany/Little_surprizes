class AddFieldSubjectToGift < ActiveRecord::Migration
   def self.up
  add_column :gifts ,:recepient_subject , :string
  add_column :gifts ,:donors_subject , :string
  end

  def self.down
  end
end
