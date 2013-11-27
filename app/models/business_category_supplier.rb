class BusinessCategorySupplier < ActiveRecord::Base
  set_table_name 'business_categories_suppliers'
	attr_accessible :supplier_id,:business_category_id,:price,:id
  # attr_accessible :title, :body


end