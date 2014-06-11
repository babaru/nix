class Project < ActiveRecord::Base
  has_and_belongs_to_many :users
  attr_accessible :name, :budget, :started_at, :ended_at, :client_id, :created_by,:user_ids
  validates :name, presence: true
  validates :budget, presence: true
  validates :budget, numericality: { greater_than: 0 }
  validates :started_at, presence: true
  validates :ended_at, presence: true
  belongs_to :client
  has_many :orders

  scope :started, where(is_started: 1)

  def is_started?
    self.is_started.to_i==1
  end

  def started_at_label
    if self.started_at.blank?
      ''
    else
      self.started_at.strftime('%Y-%m-%d')
    end
  end

  def ended_at_label
    if self.ended_at.blank?
      ''
    else
      self.ended_at.strftime('%Y-%m-%d')
    end
  end

  def get_order_info
    info = {}
    _orders = self.orders
    unless _orders.blank?
      _orders.each do |o|
        info[:all_order_price] = info[:all_order_price].to_f+o.all_price.to_f
        info[:all_order_count] =info[:all_order_count].to_i+1
        if o.is_finished?
          info[:finished_order_price] =info[:finished_order_price].to_f+ o.all_price.to_f
          info[:finished_order_count] =info[:finished_order_count].to_i+1
        end
      end
    end
    info
  end


  def self.create_new_template(project=nil)
    return if project==nil
    temp_folder_name = Rails.root.to_s + "/public/temp/"
    unless File.exist?(temp_folder_name)
      FileUtils.mkdir_p(temp_folder_name)
    end
    FileUtils.rm Dir[temp_folder_name.to_s+'*.xls']
    require "spreadsheet"
    workbook = Spreadsheet::Workbook.new

    sheet1 = workbook.create_worksheet(:name => '项目信息')
    sheet1.row(0).replace ['项目名称',project.name.to_s]
    sheet1.row(1).replace ['开始日期',(project.started_at.blank? ? '' : project.started_at.strftime('%Y-%m-%d'))]
    sheet1.row(2).replace ['结束日期',(project.ended_at.blank? ? '' : project.ended_at.strftime('%Y-%m-%d'))]
    sheet1.row(3).replace ['预算', project.budget.to_s]
    if project.is_started?
      sheet1.row(4).replace ['是否已启动','已启动','启动时间',(project.is_started? ? project.is_started_at.strftime('%Y-%m-%d %H:%M:%S') : '')]
    else
      sheet1.row(4).replace ['是否已启动','未启动']
    end
    sheet1.row(5).replace ['执行人员',(project.users.blank? ? '' : project.users.map{|u|u.name}.join(','))]


    _business_categories = BusinessCategory.where('id in (?)',project.category_ids.uniq)
    _orders = project.orders
    unless _business_categories.blank?
      format = Spreadsheet::Format.new(:pattern => 1,:color => :white, :weight => :bold, :size => 11)
      _business_categories.each do |cat|
         cat_sheet =  workbook.create_worksheet(:name => cat.name_cn)
         cat_sheet.row(0).default_format = format
         cat_sheet.row(0).replace ['名称','供应商名称','联系人','联系方式','价格','是否完成','完成时间','备注','创建人','创建时间','更新人','更新时间']
         cat_sheet.row(0).height = 18

        _cat_orders = _orders.select{|_o| _o.business_category_id == cat.id}
        unless  _cat_orders.blank?
          _cat_orders.each_with_index do |c_order,i|
            if c_order.supplier.blank?
              cat_sheet.row(i+1).replace [c_order.name,
                                          '',
                                          '',
                                          '',
                                          c_order.price.to_s,
                                          (c_order.is_finished? ? '已完成' : '未完成'),
                                          (c_order.finished_at.blank? ? '' : c_order.finished_at.strftime('%Y-%m-%d %H:%M:%S')),
                                          c_order.notes,
                                          c_order.created_name,
                                          (c_order.created_at.blank? ? '' : c_order.created_at.strftime('%Y-%m-%d')),
                                          c_order.updated_name,
                                          (c_order.updated_at.blank? ? '' : c_order.updated_at.strftime('%Y-%m-%d'))]
            else
            end
            cat_sheet.row(i+1).replace [c_order.name,
                                        c_order.supplier.name,
                                        c_order.supplier.contact_name,
                                        c_order.supplier.contact_way,
                                        c_order.price.to_s,
                                        (c_order.is_finished? ? '已完成' : '未完成'),
                                        (c_order.finished_at.blank? ? '' : c_order.finished_at.strftime('%Y-%m-%d %H:%M:%S')),
                                        c_order.notes,
                                        c_order.created_name,
                                        (c_order.created_at.blank? ? '' : c_order.created_at.strftime('%Y-%m-%d')),
                                        c_order.updated_name,
                                        (c_order.updated_at.blank? ? '' : c_order.updated_at.strftime('%Y-%m-%d'))]
          end
        end

      end
    end






    new_file = temp_folder_name + project.name.to_s+".xls"
    File.delete(new_file) if File.exist?(new_file)
    workbook.write new_file
    new_file
  end

  def self.test
    require 'yaml'
    return {'未完成'=>1,2=>'123'}.to_yaml
  end

  def category_ids
    if self.orders.blank?
      [0]
    else
      self.orders.map{|o|o.business_category_id}
    end
  end

  def valid1?
    if self.started_at and self.ended_at and self.started_at >= self.ended_at
      errors.add(:ended_at,"结束日期不能小于开始日期")
    end
    errors.size == 0
  end

  def start!
    if self.is_started == 0
      self.is_started = 1
      self.is_started_at = Time.now
      self.save!
    end
  end
end
