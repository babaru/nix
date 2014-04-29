class CreateProjectFiles < ActiveRecord::Migration
  def change
    create_table :project_files do |t|
      t.integer :project_id
      t.integer :file_category_id
      t.string :file_name #文件名
      t.string :save_name #保存后名称
      t.integer :deleted,:limit=>2,:default=>0
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
    add_index :project_files,:project_id
    add_index :project_files,:file_category_id
    add_index :project_files,:deleted
    add_index :project_files,:created_by
    add_index :project_files,:updated_by
  end
end
