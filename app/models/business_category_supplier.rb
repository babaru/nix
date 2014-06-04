class BusinessCategorySupplier < ActiveRecord::Base
  set_table_name 'business_categories_suppliers'
	attr_accessible :supplier_id,:business_category_id,:price,:id
  belongs_to :specification
  # attr_accessible :title, :body

  def get_price(supper_id)


  end
end