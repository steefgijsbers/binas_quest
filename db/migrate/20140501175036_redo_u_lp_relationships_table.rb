class RedoULpRelationshipsTable < ActiveRecord::Migration
  def change
    create_table :u_lp_relationships, force: true do |t|
      t.integer :user_id
      t.integer :levelpack_id

      t.timestamps
    end
    add_index :u_lp_relationships, :user_id
    add_index :u_lp_relationships, :levelpack_id
    add_index :u_lp_relationships, [:user_id, :levelpack_id], unique: true
  end
end
