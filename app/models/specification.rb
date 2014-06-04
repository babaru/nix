class Specification < ActiveRecord::Base
  attr_accessible :business_category_id, :name

  def get_price(supplier_id)
    return '' if supplier_id==0
    bs = SpecificationsSupplier.where('specification_id = ? and supplier_id= ?',self.id,supplier_id).first()
    return '' if bs.blank?
    bs.price.to_s.blank? ? '' : bs.price.to_s
  end
end
