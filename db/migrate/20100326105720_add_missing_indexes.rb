class AddMissingIndexes < ActiveRecord::Migration
  def self.up

    # These indexes were found by searching for AR::Base finds on your application
    # It is strongly recommanded that you will consult a professional DBA about your infrastucture and implemntation before
    # changing your database in that matter.
    # There is a possibility that some of the indexes offered below is not required and can be removed and not added, if you require
    # further assistance with your rails application, database infrastructure or any other problem, visit:
    #
    # http://www.railsmentors.org
    # http://www.railstutor.org
    # http://guides.rubyonrails.org


    add_index :category_wish_lists, :wish_list_id
    add_index :category_wish_lists, :category_id
    add_index :categories, :parent_id
    add_index :wish_lists, :user_id
    add_index :roles_users, [:role_id, :user_id]
    add_index :roles_users, [:user_id, :role_id]
  end

  def self.down
    remove_index :category_wish_lists, :wish_list_id
    remove_index :category_wish_lists, :category_id
    remove_index :categories, :parent_id
    remove_index :wish_lists, :user_id
    remove_index :roles_users, :column => [:role_id, :user_id]
    remove_index :roles_users, :column => [:user_id, :role_id]
  end
end

