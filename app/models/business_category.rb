class BusinessCategory < ActiveRecord::Base
	has_and_belongs_to_many :suppliers
	attr_accessible :name_cn,:parent_id,:created_by,:updated_by,:is_show
  belongs_to :created_man, :class_name => "User", :foreign_key => "created_by"
  belongs_to :updated_man, :class_name => "User", :foreign_key => "updated_by"
  belongs_to :parent_category, :class_name => "BusinessCategory", :foreign_key => "parent_id"
  validates :name_cn, presence:{message:'名称不能为空'}
  # attr_accessible :title, :body

  def self.first_categories
  	b = BusinessCategory.where('parent_id=0');
  	b==nil ? [] : b
  end
  def self.second_categories
  	b = BusinessCategory.where('parent_id <> 0').order('id desc');
  	b==nil ? [] : b
  end
  def children
  	bs = BusinessCategory.where('parent_id=?',self.id);
  	bs.blank? ? [] : bs
  end
  def cat_ids
    bs = BusinessCategory.where('parent_id=?',self.id);
    bs.blank? ? [self.id] : ([self.id]+bs.map{|b|b.id})
  end
  def get_price(supplier_id=0,show_type='￥')
    return '' if supplier_id==0
    bs = BusinessCategorySupplier.where('business_category_id=? and supplier_id= ?',self.id,supplier_id).first()
    return '--' if bs.blank?
    bs.price.to_s.blank? ? '未填写报价' : show_type+bs.price.to_s
  end
    def get_price1(supplier_id=0,show_type='￥')
    return '' if supplier_id==0
    bs = BusinessCategorySupplier.where('business_category_id=? and supplier_id= ?',self.id,supplier_id).first()
    return '' if bs.blank?
    bs.price.to_s.blank? ? '未填写报价' : show_type+bs.price.to_s
  end

  def self.show_categories
    b = BusinessCategory.where('is_show=1');
    b==nil ? [] : b
  end

  def created_name
    self.created_man.blank? ? '' : self.created_man.name
  end
   def updated_name
    self.updated_man.blank? ? '' : self.updated_man.name
  end
  def name
    self.name_cn
  end
  def parent_name
    self.parent_category.blank? ? '--' : self.parent_category.name_cn
  end
end
