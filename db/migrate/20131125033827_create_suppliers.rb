class CreateSuppliers < ActiveRecord::Migration
  def change
    create_table :suppliers do |t|
      t.string :name, :default => ""
      t.integer :is_personal,:limit=>2,:defaule=>0 #公司还是个人1为公司2为个人
      t.string :contact_name, :default => ""
      t.string :phone, :default => ""
      t.string :qq, :default => ""
      t.string :email, :default => ""
      t.integer :business_category_id
      t.float :price
      t.integer :client_id
      t.text :notes

      t.integer :created_by, :default => 0
      t.integer :updated_by, :default => 0

      t.timestamps
    end
    add_index :suppliers, :name
    add_index :suppliers, :contact_name
    add_index :suppliers, :phone
    add_index :suppliers, :qq
    add_index :suppliers, :email
    add_index :suppliers, :is_personal
    add_index :suppliers, :price

  end
end
