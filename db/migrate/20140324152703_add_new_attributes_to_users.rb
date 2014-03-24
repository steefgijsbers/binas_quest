class AddNewAttributesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :password_digest, :string
    add_column :users, :klas, :string
    add_column :users, :progress, :string
  end
end
