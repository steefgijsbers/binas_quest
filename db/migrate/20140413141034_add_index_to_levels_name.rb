class AddIndexToLevelsName < ActiveRecord::Migration
  def change
    add_index :levels, :name, unique: true
  end
end
