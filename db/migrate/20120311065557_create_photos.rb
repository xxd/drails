class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.references :user
      t.references :item
      t.string :file_uri
      t.string :salt

      t.timestamps
    end
    add_index :photos, :user_id
    add_index :photos, :item_id
  end
end
