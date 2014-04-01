class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.integer :client_id
      t.integer :created_by
      t.integer :updated_by
      t.datetime :started_at
      t.datetime :ended_at
      t.integer :budget
      t.integer :is_started,:limit=>2,:default=>0
      t.datetime :is_started_at
      t.integer :business_category_id

      t.timestamps
    end
    add_index :projects, :client_id
    add_index :projects, :created_by
    add_index :projects, :updated_by
    add_index :projects, :business_category_id
  end
end
