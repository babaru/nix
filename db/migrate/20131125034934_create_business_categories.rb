class CreateBusinessCategories < ActiveRecord::Migration
  def change
    create_table :business_categories do |t|
    	t.string :name_cn, :default => ""
    	t.integer :parent_id, :default => 0
        t.integer :is_show,:default => 0
    	t.integer :created_by, :default => 0
    	t.integer :updated_by, :default => 0

        t.timestamps
    end
    add_index :business_categories, :is_show
    add_index :business_categories, :name_cn
    add_index :business_categories, :parent_id
    add_index :business_categories, :created_by
    add_index :business_categories, :updated_by
  end
end
