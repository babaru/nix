class Supplier < ActiveRecord::Base
  attr_accessible :name, :contact_name, :contact_way, :business_category_ids,:specification_ids, :created_by, :updated_by,:is_personal,:phone, :qq, :email, :business_category_id, :price, :client_id, :notes
  has_and_belongs_to_many :business_categories
  has_and_belongs_to_many :specifications
  belongs_to :created_man, :class_name => "User", :foreign_key => "created_by"
  belongs_to :updated_man, :class_name => "User", :foreign_key => "updated_by"
  TITLE_ITEMS=[]
  validates :contact_name, presence:{message:'联系人不能为空'}
  validates :business_category_id, presence:{message:'规格不能为空'}
  validates :price, numericality: { greater_than: 0 }
  validates :price, presence:{message:'价格不能为空'}
  validates :client_id, presence:{message:'服务客户不能为空，若没有请先添加客户'}
  validates :is_personal, presence:{message:'公司/个人不能为空'}
  has_many :orders
  has_many :supplier_evaluations,:order=>'id desc'
  has_many :specifications_suppliers
  belongs_to :business_category
  belongs_to :client

  def other_valid?
  if self.phone.blank? and self.qq.blank? and self.email.blank?
    errors.add(:phone,"3种联系方式不能同时为空")
    errors.add(:qq,"3种联系方式不能同时为空")
    errors.add(:email,"3种联系方式不能同时为空")
  end
  errors.size == 0
  end

  def show_name
    self.name.blank? ? self.contact_name : self.name
  end


  def category_ids
  	bs = self.business_categories
  	bs.blank? ? [] : bs.map{|b| b.id}
  end

  def clients
    Client.all.map{|x| [x.name,x.id]}
  end

  def spec_name
    bc = self.business_category
    bc.blank? ? '' : bc.parent_category.name_cn+'-'+bc.name_cn
  end

  def client_name
    cl = self.client
    cl.blank? ? '' : cl.name
  end

  def specification_ids
    bcs_ids = [0]
    bcs = self.specifications
    bcs_ids = bcs.map{|x|x.id} unless bcs.blank?
    bcs_ids
  end

  def all_specification_names
    item = ''.html_safe
    self.specifications.each do |s|
      item += s.show_name.to_s.html_safe+'<br>'.html_safe
    end
    item
  end

  def all_specification_price
    item = ''.html_safe
    self.specifications_suppliers.each do |s|
      item += s.price.to_s.html_safe+'<br>'.html_safe
    end
    item
  end

  def specification_notes
    ses = self.supplier_evaluations
    ses.blank? ? '' : ses[0].notes
  end

  def avg_score
    se = SupplierEvaluation.find_by_sql(['select avg(score) as score from supplier_evaluations where supplier_id = ? ',self.id])
    se.blank? ? '' : se.first().score

    #ses = self.supplier_evaluations
    #ses_ids = ses.map{|x| x.id} unless ses.blank?
    #sps = self.specifications
    #sp_ids = sps.map{|x| x.id} unless sps.blank?
    #se_items = SupplierEvaluationItem.find_by_sql(['select avg(score) as score from supplier_evaluation_items where specification_id in (?) and supplier_evaluation_id in (?)  group by specification_id',sp_ids,ses_ids])
    #item = ''.html_safe
    #unless se_items.blank?
    #  se_items.each do |sit|
    #    item += sit.score.to_s.html_safe+'<br>'.html_safe
    #  end
    #end
    #item
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
    excel_title = ['ID','供应商名称','公司/个人','联系人','联系电话','QQ','Email','规格','单价','服务客户','备注']
    excel_title += ['平均分','评价'] unless suppliers.nil?
    format = Spreadsheet::Format.new(:color => :black,:horizontal_align => :center,:pattern_fg_color=>'silver',:pattern=>1, :size => 10,:border_color=>:black,:border=>:thin)
    sheet1.row(0).default_format = format
    [2,3,7,8,9].each do |index|
      sheet1.row(0).set_format(index,Spreadsheet::Format.new(:color => :red,:horizontal_align => :center,:pattern_fg_color=>'silver',:pattern=>1, :size => 10,:border_color=>:black,:border=>:thin))
    end
    [4,5,6].each do |index|
      sheet1.row(0).set_format(index,Spreadsheet::Format.new(:color => :blue,:horizontal_align => :center,:pattern_fg_color=>'silver',:pattern=>1, :size => 10,:border_color=>:black,:border=>:thin))
    end
    sheet1.row(0).replace excel_title
    sheet2 = workbook.create_worksheet(:name => '供应商Excel说明')
    sheet2.row(0).replace ['1.下载的供应商列表可以直接进行上传，其中如果填写ID则表示对该条已有数据进行修改，如果没有填写ID则代表是增加一条新的供应商记录。']
    sheet2.row(1).replace ["2.某些涉及的内容要求一定要规范填写如 \"规格\",\"服务客户\"等，如果不确定请从页面复制粘贴。"]
    sheet2.row(2).replace ["3.上传的供应商数据中不包括\"平均分\"和\"评价\"，此两项需要上传数据以后在页面进行操作。"]
    sheet2.row(3).replace ['4.下载供应商Excel是根据你所提供的查询条件，如果想下载全部供应商则请去掉所有查询条件。']
    sheet2.row(4).replace ['5.如有其他问题请联系 于洋(创意部) QQ:234016483 电话:18641013958']
    sheet2.row(5).replace ["6.上传数据库请注意，红色项必须填写，蓝色项中必须填写一项。"]
    if suppliers.nil?
       new_file = temp_folder_name + "供应商模板-#{Time.now.strftime('%Y-%m-%d')}.xls"
    else
      ActiveRecord::Base.transaction do
        suppliers.each_with_index do |s,i|
          sheet1.row(i+1).replace [s.id.to_s,
                                   s.name,
                                   (s.is_personal.to_i==1 ? '公司' : '个人'),
                                   s.contact_name,
                                   s.phone,
                                   s.qq,
                                   s.email,
                                   s.spec_name,
                                   s.price.to_s,
                                   s.client_name,
                                   s.notes,
                                   s.avg_score,
                                   s.specification_notes]
        end
      end
      new_file = temp_folder_name + "供应商列表-#{Time.now.strftime('%Y-%m-%d')}.xls"
    end
    
    File.delete(new_file) if File.exist?(new_file)
    workbook.write new_file
    new_file
  end

  def get_order_info(selected_id=0)
    info = {}
    _orders = self.orders
    unless _orders.blank?
      _orders.each do |o|
        info[:all_order_price] = info[:all_order_price].to_f+o.price.to_f
        info[:all_order_count] =info[:all_order_count].to_i+1
        if o.business_category_id.to_i == selected_id
          info[:select_order_price] = info[:select_order_price].to_f+o.price.to_f
          info[:select_order_count] =info[:select_order_count].to_i+1
          if o.is_finished?
            info[:select_finished_order_price] = info[:select_finished_order_price].to_f+o.price.to_f
            info[:select_finished_order_count] =info[:select_finished_order_count].to_i+1
          end
        end
        if o.is_finished?
          info[:finished_order_price] =info[:finished_order_price].to_f+ o.price.to_f
          info[:finished_order_count] =info[:finished_order_count].to_i+1
        end
      end
    end
    info
  end

  def self.create_suppliers_by_excel(_sheet=nil,user=nil)
    _error_info = ''
    _error_info = '上传文件错误，请重新上传！' if _sheet.nil? or user.nil?
    ActiveRecord::Base.transaction do
      _sheet.each_with_index do |row,index|
        next if index==0
        if row[0].to_s.strip.blank?
          data = Supplier.new({:created_by=>user.id})
        else
          data = Supplier.find_by_id(row[0].to_s.to_i)
          if data.blank?
            _error_info = 'ID错误，在第'+index.to_s+'行' if data.blank?
            break
          end
        end
        data.name = row[1].to_s

        if row[2].to_s.strip.blank?
          _error_info = '公司/个人 不能为空！，在第'+index.to_s+'行'
          break
        else
          data.is_personal = (row[2].to_s.strip=='公司' ? 1 : 2)
        end

        if row[3].to_s.strip.blank?
          _error_info = '联系人 不能为空！，在第'+index.to_s+'行'
          break
        else
          data.contact_name = row[3].to_s.strip
        end

        if row[4].to_s.strip.blank? and row[5].to_s.strip.blank? and row[6].to_s.strip.blank?
          _error_info = '电话，QQ，Email 不能同时为空！，在第'+index.to_s+'行'
          break
        else
          data.phone = row[4].to_s.strip
          data.qq = row[5].to_s.strip
          data.email = row[6].to_s.strip
        end

        if row[7].to_s.strip.blank?
          _error_info = '规格 不能为空！，在第'+index.to_s+'行'
          break
        else
          spec_info = row[7].to_s.strip.split('-')
          _cat = BusinessCategory.find_by_name_cn(spec_info[0].to_s)
          if _cat.blank?
            _error_info = '规格填写有误，请检查！，在第'+index.to_s+'行'
            break
          else
            spec = BusinessCategory.where('name_cn = ? and parent_id = ?',spec_info[1],_cat.id).first()
            if spec.blank?
              _error_info = '规格填写有误，请检查！，在第'+index.to_s+'行'
              break
            else
              data.business_category_id = spec.id
            end
          end
          data.contact_name = row[3].to_s.strip
        end

        if row[8].to_s.strip.blank?
          _error_info = '价格 不能为空！，在第'+index.to_s+'行'
          break
        else
          data.price = row[8].to_s.strip.to_f
        end

        if row[9].to_s.strip.blank?
          _error_info = '服务客户 不能为空！，在第'+index.to_s+'行'
          break
        else
          _client = Client.find_by_name(row[9].to_s.strip)
          if _client.blank?
            _error_info = '服务客户填写有误，请检查！，在第'+index.to_s+'行'
            break
          else
            data.client_id = _client.id
          end
        end
        data.updated_by = user.id
        data.notes = row[10].to_s
        data.save
      end
      if _error_info != ''
        raise ActiveRecord::Rollback
      end
    end
    _error_info
  end



end
