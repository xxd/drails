class CreateVoices < ActiveRecord::Migration
  def change
    create_table :voices do |t|
      t.references :user
      t.references :item
      t.string :file_uri
      t.string :salt

      t.timestamps
    end
    add_index :voices, :user_id
    add_index :voices, :item_id
  end
end
