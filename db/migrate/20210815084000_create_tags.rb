class CreateTags < ActiveRecord::Migration[6.0]
  def change
    change_column_null :tags, :name, false
    add_index :tags, :name
  end
end
