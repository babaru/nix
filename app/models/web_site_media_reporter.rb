class WebSiteMediaReporter < ActiveRecord::Base
  attr_accessible     :region_id, :province_id, :city_id, :format_id, :media_name, :level, :name, :sex, :department_name, :job_name, :telephone, :mobile, :email, :instant_messaging, :micro_blog, :micro_message, :office_address, :working_conditions, :birthday, :id_number, :origin_place, :has_children, :has_car, :other_about, :active_record, :maintenance_record, :notes
  belongs_to :province
  belongs_to :city
  belongs_to :region
  belongs_to :created_man, :class_name => "User", :foreign_key => "created_by"
  belongs_to :updated_man, :class_name => "User", :foreign_key => "updated_by"

  validates :region_id, presence: true
  validates :province_id, presence: true
  validates :city_id, presence: true
  validates :format_id, presence: true
  validates :media_name, presence: true
  validates :level, presence: true
  validates :name, presence: true
  validates :sex, presence: true
  validates :department_name, presence: true
  validates :job_name, presence: true
  validates :telephone, presence: true
  validates :mobile, presence: true
  validates :email, presence: true
  validates :instant_messaging, presence: true
  validates :micro_blog, presence: true
  validates :micro_message, presence: true
  validates :office_address, presence: true
  validates :birthday, presence: true
  validates :id_number, presence: true
  validates :origin_place, presence: true
  validates :has_children, presence: true
  validates :has_car, presence: true
  validates :other_about, presence: true
  validates :active_record, presence: true
  ATTR=['media_name','level','name','sex','department_name','job_name','telephone','mobile','email','instant_messaging','micro_blog','micro_message','office_address','working_conditions','birthday','id_number','origin_place','married','has_children','has_car','other_about','active_record','maintenance_record','notes']


  def other_valid?
    if self.region_id.to_i==0
      errors.add(:region_id,"请选择地区")
    end
    if self.province_id.to_i==0
      errors.add(:province_id,"请选择省份")
    end
    if self.city_id.to_i==0
      errors.add(:city_id,"请选择城市")
    end


    errors.size == 0
  end

  def created_name
    self.created_man.blank? ? '' : self.created_man.name
  end
  def updated_name
    self.updated_man.blank? ? '' : self.updated_man.name
  end
  def province_name
    self.province.blank? ? '' : self.province.name
  end
  def region_name
    self.region.blank? ? '' : self.region.name
  end
  def city_name
    self.city.blank? ? '' : self.city.name
  end

  def self.create_new_template(data=nil)
    temp_folder_name = Rails.root.to_s + "/public/temp/"
    unless File.exist?(temp_folder_name)
      FileUtils.mkdir_p(temp_folder_name)
    end
    FileUtils.rm Dir[temp_folder_name.to_s+'*.xls']
    require "spreadsheet"
    workbook = Spreadsheet::Workbook.new

    sheet1 = workbook.create_worksheet(:name => '记者基本信息')
    format = Spreadsheet::Format.new(:pattern => 1,:color => :white, :weight => :bold, :size => 11)
    sheet1.row(0).default_format = format
    sheet1.row(0).replace ['区域','省份','城市','媒体介质','媒体名称','媒体级别','姓名','性别','部门名称','职务名称','电话','手机','邮箱','即时通讯','微博','微信','办公地址','从业情况','生日','身份证号','籍贯','已婚？','是否有子女（性别）','是否有车（品牌）','其他（个人兴趣，爱好）','活动记录','维护记录','备注','创建时间','创建人','更新时间','更新人']
    sheet1.row(0).height = 18
    unless data.blank?
      data.each_with_index do |d,i|
        attr = [d.region_name,d.province_name,d.city_name,d.format_id]
        WebSiteMediaReporter::ATTR.each do |a|
          if a=='married'
            attr << ((d[a].blank? or d[a]==false) ? '未婚' : '已婚')
          elsif a== 'sex'
            attr << (d[a].to_i ==0 ? '女' : '男')
          else
            attr << d[a]
          end
        end
        attr = attr + [d.created_at.strftime('%Y-%m-%d'),d.created_name,d.updated_at.strftime('%Y-%m-%d'),d.updated_name]
        sheet1.row(i+1).replace attr
      end
    end

    new_file = temp_folder_name + "媒体资源库-记者基本信息.xls"
    File.delete(new_file) if File.exist?(new_file)
    workbook.write new_file
    new_file

  end

  def self.create_by_excel(_sheet=nil,user=nil)
    return false if _sheet.nil? or user.nil?
     msg = false
    ActiveRecord::Base.transaction do
      _sheet.each_with_index do |row,index|
        next if index==0 or row[0].strip.blank?
        _reporter = WebSiteMediaReporter.new()
        _region_name = row[0].strip
        _region = Region.where("name like ?","%#{_region_name}%").first
        if _region.blank?
          raise ActiveRecord::Rollback
          break
        end
        _reporter.region_id=_region.id

        _province_name = row[1].strip
        _province = Province.where("name like ?","%#{_province_name}%").first
        if _province.blank?
          raise ActiveRecord::Rollback
          break
        end
        _reporter.province_id=_province.id

        _city_name = row[2].strip
        _city = City.where("name like ?","%#{_city_name}%").first
        if _city.blank?
          raise ActiveRecord::Rollback
          break
        end
        _reporter.city_id=_city.id

        _reporter.format_id=row[3]

        WebSiteMediaReporter::ATTR.each_with_index do |a,_index|

          if a=='married'
            _reporter.married=(row[_index+4].to_s.strip=="未婚" ? false : true)
          elsif a== 'sex'
            _reporter.sex=(row[_index+4].to_s.strip=="男" ? 1 : 0)
          else
            _reporter[a.to_s]=row[_index+4]
          end



        end


        _reporter.created_at=Time.now
        _reporter.updated_at=Time.now
        _reporter.created_by=user.id
        _reporter.updated_by=user.id
        msg =  _reporter.save
      end
    end
    return msg
  end


end





























