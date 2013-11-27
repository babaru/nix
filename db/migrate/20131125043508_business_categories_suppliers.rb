class BusinessCategoriesSuppliers < ActiveRecord::Migration
  def up
  	 create_table :business_categories_suppliers do |t|
    	t.integer :supplier_id, :default => 0
    	t.integer :business_category_id, :default => 0
      t.string :price, :default => ''
        t.timestamps
    end
    add_index :business_categories_suppliers, :supplier_id
    add_index :business_categories_suppliers, :business_category_id
    add_index :business_categories_suppliers, :price
  end

  def down
  	drop_table :business_categories_suppliers
  end
end
