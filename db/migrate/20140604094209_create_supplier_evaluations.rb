class CreateSupplierEvaluations < ActiveRecord::Migration
  def change
    create_table :supplier_evaluations do |t|
      t.integer :supplier_id
      t.float :score
      t.text :notes
      t.integer :created_by
      t.integer :updated_by
      t.timestamps
    end
  end
end
