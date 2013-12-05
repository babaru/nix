class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
  	    t.string :name
        t.string :logo
        t.integer :created_by, :default => 0
      	t.integer :updated_by, :default => 0
        t.timestamps
    end
    	add_index :clients, :created_by
    	add_index :clients, :updated_by
  end
end
