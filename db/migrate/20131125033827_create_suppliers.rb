class CreateSuppliers < ActiveRecord::Migration
  def change
    create_table :suppliers do |t|
      t.string :name, :default => ""
      t.string :contact_name, :default => ""
      t.string :contact_way, :default => ""
      t.integer :created_by, :default => 0
      t.integer :updated_by, :default => 0

      t.timestamps
    end
    add_index :suppliers, :name
    add_index :suppliers, :contact_name
    add_index :suppliers, :contact_way
  end
end
