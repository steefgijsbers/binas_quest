class AddColumnToLevel < ActiveRecord::Migration
  def change
    add_column :levels, :levelpack_id, :integer
    add_index  :levels, :levelpack_id, unique: true
  end
end
