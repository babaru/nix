class CreateSpecifications < ActiveRecord::Migration
  def change
    create_table :specifications do |t|
      t.integer :business_category_id
      t.string :name
    end
    add_index :specifications,:business_category_id
  end
end
