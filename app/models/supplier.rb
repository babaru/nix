class Supplier < ActiveRecord::Base
  attr_accessible :name, :contact_name, :contact_way, :business_category_ids, :created_by, :updated_by
  has_and_belongs_to_many :business_categories
  belongs_to :created_man, :class_name => "User", :foreign_key => "created_by"
  belongs_to :updated_man, :class_name => "User", :foreign_key => "updated_by"
  TITLE_ITEMS=[]
  validates :contact_name, presence:{message:'联系人不能为空'}
  validates :contact_way, presence:{message:'联系方式不能为空'}


  def category_ids
  	bs = self.business_categories
  	bs.blank? ? [] : bs.map{|b| b.id}
  end
    def created_name
    self.created_man.blank? ? '' : self.created_man.name
  end
   def updated_name
    self.updated_man.blank? ? '' : self.updated_man.name
  end

  def self.create_new_template(suppliers=nil)
    temp_folder_name = Rails.root.to_s + "/public/temp/"
    unless File.exist?(temp_folder_name)
      FileUtils.mkdir_p(temp_folder_name)
    end
    FileUtils.rm Dir[temp_folder_name.to_s+'*.xls']
    require "spreadsheet"
    workbook = Spreadsheet::Workbook.new

    sheet1 = workbook.create_worksheet(:name => '供应商列表')
    categories = BusinessCategory.second_categories
    excel_title = ['供应商名称','联系人','联系方式']
    categories.each do |c|
      excel_title << c.name_cn
    end
    excel_title = excel_title + ['创建人','创建时间','更新人','更新时间']
    format = Spreadsheet::Format.new(:pattern => 1,:color => :white, :weight => :bold, :size => 11)
    sheet1.row(0).default_format = format
    sheet1.row(0).replace excel_title
    sheet1.row(0).height = 18
    if suppliers.nil?
       new_file = temp_folder_name + "供应商模板.xls"
    else
      ActiveRecord::Base.transaction do
      suppliers.each_with_index do |s,i|
        excel_item = [s.name.to_s,s.contact_name.to_s,s.contact_way.to_s]
        categories.each do |c|
          excel_item << c.get_price1(s.id,'')
        end
        excel_item = excel_item + [s.created_name,s.created_at.blank? ? '' : s.created_at.strftime('%Y-%m-%d'),s.updated_name,s.updated_at.blank? ? '' : s.updated_at.strftime('%Y-%m-%d')]
        sheet1.row(i+1).replace excel_item
      end
      end
      new_file = temp_folder_name + "供应商列表-#{Time.now.strftime('%Y-%m-%d')}.xls"
    end
    
    File.delete(new_file) if File.exist?(new_file)
    workbook.write new_file
    new_file
  end

  def self.create_suppliers_by_excel(supplier_sheet=nil,user=nil)
    return if supplier_sheet.nil? or user.nil?
    _categories = BusinessCategory.second_categories
    _category_map = []
    _category_map = _categories.map{|c| [c.name_cn.to_s,c.id]} unless _categories.blank?
    _cat_len = _categories.to_a.size
    ActiveRecord::Base.transaction do
      supplier_sheet.each_with_index do |row,index|
        next if index==0
        _supplier = Supplier.new()
        _supplier.name=row[0]
        _supplier.contact_name=row[1]
        _supplier.contact_way=row[2]
        _supplier.created_by = user.id
        _supplier.updated_by = user.id
        _supplier.save
        if _cat_len>0
          (1.._cat_len).each do |index|

            c_id = _category_map.find{|cat| cat[0]==supplier_sheet[0,(2+index)].to_s}.to_a[1].to_i
            if c_id > 0 and row[2+index].to_s.strip != ''
              BusinessCategorySupplier.create({:supplier_id=>_supplier.id,:business_category_id=>c_id,:price=>row[2+index].to_s})
            end
          end
        end
      end
    end
  end



end
