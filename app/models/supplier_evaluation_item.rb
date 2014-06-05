class SupplierEvaluationItem < ActiveRecord::Base
  attr_accessible :supplier_evaluation_id, :score,:specification_id

  def self.show_score(supplier_evaluation_id,specification_id)
   se =  SupplierEvaluationItem.where('supplier_evaluation_id=? and specification_id = ?',supplier_evaluation_id,specification_id)
   se.blank? ? '' : se.first().score
  end
end
