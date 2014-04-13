class CreateLevels < ActiveRecord::Migration
  def change
    create_table :levels do |t|
      t.string :name
      t.string :img_src
      t.string :solution

      t.timestamps
    end
  end
end
