class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      
      t.string :first_name
      t.string :last_name
      t.string :gender
      t.date   :date_of_birth
      t.date   :anniversary_date
      t.date   :special_date
      t.string :religion
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
      t.string :marital_status
      t.string :login
      t.string :email
      t.string :crypted_password
      t.string :password_salt
      t.string :persistence_token
      t.integer :facebook_id
      t.string :session_key
      t.timestamps
      #t.integer :login_count, :default => 0
      #t.datetime :last_request_at
      #t.datetime :last_login_at
      #t.datetime :current_login_at
      #t.string :last_login_ip
      #t.string :current_login_ip
    end
    execute "alter table users modify facebook_id bigint"
    
    add_index :users, :login
    add_index :users, :persistence_token
    #add_index :users, :last_request_at

    create_table :roles do |t|
      t.column :name, :string
    end
    
    # generate the join table
    create_table :roles_users, :id => false do |t|
      t.column :role_id, :integer
      t.column :user_id, :integer
    end
    
    # Create admin role and user
    admin_role = Role.create(:name => 'admin')
    
    user = User.create do |u|
      u.login = 'admin'
      u.password = u.password_confirmation = 'admin64'
      u.email = 'nospam@example.com'
    end
    
    #user.register!
    #user.activate!
    user.roles << admin_role

  end

  def self.down
    drop_table :users
  end
end
