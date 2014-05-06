class DeleteLevelpackIdFromLevel < ActiveRecord::Migration
  def change
    remove_column :levels, :levelpack_id
  end
end
