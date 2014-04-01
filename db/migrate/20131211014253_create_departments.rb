class CreateDepartments < ActiveRecord::Migration
  def change
    create_table :departments do |t|
      t.string :name
      t.integer :space_id
      t.integer :city_id
      t.integer :province_id

      t.timestamps
    end
    add_index :departments, :space_id
    add_index :departments, :city_id
    add_index :departments, :province_id
  end
end
