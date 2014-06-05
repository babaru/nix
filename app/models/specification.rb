class Specification < ActiveRecord::Base
  attr_accessible :business_category_id, :name
  belongs_to :business_category

  def get_price(supplier_id)
    return '' if supplier_id==0
    bs = SpecificationsSupplier.where('specification_id = ? and supplier_id= ?',self.id,supplier_id).first()
    return '' if bs.blank?
    bs.price.to_s.blank? ? '' : bs.price.to_s
  end

  def get_avg_score(supplier)
    ses_ids = [0]
    ses = supplier.supplier_evaluations
    ses_ids = ses.map{|x| x.id} unless ses.blank?
    se_items = SupplierEvaluationItem.find_by_sql(['select avg(score) as score from supplier_evaluation_items where specification_id = ? and supplier_evaluation_id in (?)',self.id,ses_ids])
    se_items[0].score.blank? ? '' : ' / '+se_items[0].score.to_s
  end

  def show_name
   bc = self.business_category
    if bc.blank?
      self.name
    else
      bc.name_cn.to_s+'-'+self.name.to_s
    end
  end
end
