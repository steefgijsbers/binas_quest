class AddThumbSrcToLevels < ActiveRecord::Migration
  def change
    add_column :levels, :thumb_src, :string
  end
end
