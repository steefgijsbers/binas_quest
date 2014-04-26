class DeleteLevelpack < ActiveRecord::Migration
  def up
    drop_table :levelpacks
  end
  
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
