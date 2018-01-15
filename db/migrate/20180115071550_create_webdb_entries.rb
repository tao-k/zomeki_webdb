class CreateWebdbEntries < ActiveRecord::Migration[5.0]
  def change
    create_table :webdb_entries do |t|
      t.integer    :db_id
      t.string     :title
      t.jsonb     :item_values
      t.integer    :editor_id
      t.timestamps
    end
  end
end
