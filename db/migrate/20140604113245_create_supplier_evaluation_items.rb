class CreateSupplierEvaluationItems < ActiveRecord::Migration
  def change
    create_table :supplier_evaluation_items do |t|
      t.integer :supplier_evaluation_id
      t.integer :specification_id
      t.integer :score
      t.timestamps
    end
  end
end
