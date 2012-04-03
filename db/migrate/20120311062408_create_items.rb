class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.references :user
      t.references :list
      
      t.string :name, :limit => 80, :null => false
      t.string :nickname, :limit => 30, :null => false
      t.string :avatar_url, :limit => 140
      
      t.text :content

      t.timestamps
    end
    add_index :items, :user_id
    add_index :items, :list_id
  end
end
