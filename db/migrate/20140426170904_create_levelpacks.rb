class CreateLevelpacks < ActiveRecord::Migration
  def change
    create_table :levelpacks do |t|

      t.string :name
      t.string :title
      t.string :solution
      t.timestamps
    end
    add_index :levelpacks, :name, unique: true
  end
end
