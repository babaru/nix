class CreateSpecificationsSuppliers < ActiveRecord::Migration
  def change
    create_table :specifications_suppliers do |t|
      t.integer :specification_id
      t.integer :supplier_id
      t.float :price
    end
  end
end
