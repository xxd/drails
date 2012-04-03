class CreateLists < ActiveRecord::Migration
  def change
    create_table :lists do |t|
      t.references :user
      t.string :title, :limit => 80, :null => false
      
      t.string :name, :limit => 80, :null => false
      t.string :nickname, :limit => 30, :null => false
      t.string :avatar_url, :limit => 140
      
      t.integer :category_id

      t.timestamps
    end
    add_index :lists, :user_id
    add_index :lists, :category_id
  end
end
