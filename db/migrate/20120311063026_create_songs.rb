class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.references :user
      t.references :item
      t.string :name
      t.string :player
      t.string :album_name
      t.date :album_year
      t.string :album_cover
      t.string :salt
      
      t.timestamps
    end
    add_index :songs, :user_id
    add_index :songs, :item_id
  end
end
