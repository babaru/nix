class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :name
      t.integer :project_id
      t.integer :business_category_id
      t.integer :supplier_id
      t.integer :is_finished,:limit=>2,:default=>0
      t.datetime :finished_at
      t.decimal :price,:precision => 8, :scale => 2,:default => 0
      t.integer :created_by
      t.integer :updated_by
      t.text :notes

      t.timestamps
    end
    add_index :orders,:project_id
    add_index :orders,:business_category_id
    add_index :orders,:supplier_id
    add_index :orders,:is_finished
    add_index :orders,:finished_at
    add_index :orders,:price
    add_index :orders,:created_by
    add_index :orders,:updated_by
  end
end
