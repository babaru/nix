class CreateDepartmentUsers < ActiveRecord::Migration
  def change
    create_table :department_users do |t|
      t.integer :department_id
      t.integer :user_id

      t.timestamps
    end
    add_index :department_users, :department_id
    add_index :department_users, :user_id
  end
end
