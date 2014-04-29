class CreateFileCategories < ActiveRecord::Migration
  def change
    create_table :file_categories do |t|
      t.integer :project_id
      t.integer :parent_id,:default=>0
      t.string :category_name #文件名
      t.integer :deleted,:limit=>2,:default=>0
      t.integer :created_by
      t.integer :updated_by
      t.timestamps
    end
    add_index :file_categories,:project_id
    add_index :file_categories,:parent_id
    add_index :file_categories,:deleted
    add_index :file_categories,:created_by
    add_index :file_categories,:updated_by
  end
end
