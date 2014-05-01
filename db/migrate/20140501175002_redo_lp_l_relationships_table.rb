class RedoLpLRelationshipsTable < ActiveRecord::Migration
  def change
    create_table :lp_l_relationships, force: true do |t|
      t.integer :levelpack_id
      t.integer :level_id

      t.timestamps
    end
    add_index :lp_l_relationships, :levelpack_id
    add_index :lp_l_relationships, :level_id
    add_index :lp_l_relationships, [:levelpack_id, :level_id], unique: true
  end
end
