class CreateProvinces < ActiveRecord::Migration
  def change
    create_table :provinces do |t|
     t.string :name
     t.integer :region_id
     t.string :remark

    end
    add_index :provinces, :name
    add_index :provinces, :region_id
    add_index :provinces, :remark
  end
end
