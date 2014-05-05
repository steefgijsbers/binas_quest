class DeleteProgressFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :progress
  end
end
