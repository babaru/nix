class SupplierEvaluation < ActiveRecord::Base
  attr_accessible :supplier_id, :specification_id, :score, :notes, :created_by, :updated_by
  belongs_to :specification
  belongs_to :created_man, :class_name => "User", :foreign_key => "created_by"
  belongs_to :updated_man, :class_name => "User", :foreign_key => "updated_by"

  def self.show_score(supplier_id,specification_id)
    s = SupplierEvaluation.where('supplier_id=? and specification_id=?',supplier_id,specification_id)
    s.blank? ? '' : s.first().score
  end

  def created_name
    self.created_man.blank? ? '' : self.created_man.name
  end
  def updated_name
    self.updated_man.blank? ? '' : self.updated_man.name
  end
end
