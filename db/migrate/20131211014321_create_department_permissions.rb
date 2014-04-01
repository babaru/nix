class CreateDepartmentPermissions < ActiveRecord::Migration
  def change
    create_table :department_permissions do |t|
      t.integer :department_id
      t.integer :permission_id

      t.timestamps
    end
    add_index :department_permissions, :department_id
    add_index :department_permissions, :permission_id
  end
end
