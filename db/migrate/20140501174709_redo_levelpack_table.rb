class RedoLevelpackTable < ActiveRecord::Migration
  def change
    create_table :levelpacks, force: true do |t|

      t.string :name
      t.string :title
      t.string :solution
      t.timestamps
    end
    add_index :levelpacks, :name, unique: true
  end
end
