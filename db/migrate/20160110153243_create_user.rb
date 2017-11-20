class CreateUser < ActiveRecord::Migration[4.2]
  def change
    create_table :users do |t|
      t.string :username
      t.string :name
      t.string :email
      t.string :role
      t.string :ip
      t.datetime :last_login
      t.timestamps null: false
    end
    add_index :users, :username, unique: true
  end
end
