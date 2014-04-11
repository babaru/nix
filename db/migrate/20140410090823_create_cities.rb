class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string :name
      t.integer :province_id
    end
    add_index :cities, :province_id
    add_index :cities, :name
  end
end
