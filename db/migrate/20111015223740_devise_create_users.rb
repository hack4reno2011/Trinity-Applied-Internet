class DeviseCreateUsers < ActiveRecord::Migration
  def change
    create_table(:users, :id => false) do |t|
      t.string  :uuid, :limit => 36, :primary => true, :null => false
      t.string  :first_name
      t.string  :last_name
      t.string  :time_zone 
      t.boolean :deleted, :null => false, :default => false

      t.database_authenticatable :null => false
      t.recoverable
      t.rememberable
      t.trackable
      t.encryptable
      t.confirmable
      t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :both
      t.token_authenticatable
      
      t.timestamps
    end

    add_index :users, :email,                :unique => true
    add_index :users, :reset_password_token, :unique => true
    add_index :users, :confirmation_token,   :unique => true
    add_index :users, :unlock_token,         :unique => true
    add_index :users, :authentication_token, :unique => true
  end
end
