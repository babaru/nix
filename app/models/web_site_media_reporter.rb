class WebSiteMediaReporter < ActiveRecord::Base
  attr_accessible     :region_id, :is_substation,:province_id, :city_id,:married, :format_id, :media_name, :level, :name, :sex, :department_name, :job_name, :telephone, :mobile, :email, :instant_messaging, :micro_blog, :micro_message, :office_address, :working_conditions, :birthday, :id_number, :origin_place, :has_children, :has_car, :other_about, :active_record, :maintenance_record, :notes
  belongs_to :province
  belongs_to :city
  belongs_to :region
  belongs_to :created_man, :class_name => "User", :foreign_key => "created_by"
  belongs_to :updated_man, :class_name => "User", :foreign_key => "updated_by"

  # validates :region_id, presence: true
  # validates :province_id, presence: true
  # validates :city_id, presence: true
  # validates :format_id, presence: true
  # validates :media_name, presence: true
  # validates :level, presence: true
  # validates :name, presence: true
  # validates :sex, presence: true
  # validates :department_name, presence: true
  # validates :job_name, presence: true
  # validates :telephone, presence: true
  # validates :mobile, presence: true
  # validates :email, presence: true
  # validates :instant_messaging, presence: true
  # validates :micro_blog, presence: true
  # validates :micro_message, presence: true
  # validates :office_address, presence: true
  # validates :birthday, presence: true
  # validates :id_number, presence: true
  # validates :origin_place, presence: true
  # validates :has_children, presence: true
  # validates :has_car, presence: true
  # validates :other_about, presence: true
  # validates :active_record, presence: true
  ATTR=['media_name','level','name','sex','department_name','job_name','telephone','mobile','email','instant_messaging','micro_blog','office_address','working_conditions','birthday','id_number','origin_place','married','has_children','has_car','other_about','active_record','maintenance_record','notes']
  FORMATS=[['财经门户',1],['党政门户',2],['核心垂直',3],['核心门户',4],['论坛',5],['论坛分站',6],['论坛媒体',7],['门户分站',8],['汽车垂直',9],['汽车垂直分站',10],['区域垂直',11],['区域分站',12],['区域论坛',13],['区域媒体',14],['区域门户',15],['社区门户',16],['视频',17],['视频分站',18],['综合门户',19]]
  LEVELS = [['A','A'],['B','B'],['C','C'],['D','D'],['E','E'],['F','F'],['G','G'],['H','H'],['I','I']]
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
    if self.is_substation==1
      '分站'
    else
      self.region.blank? ? '' : self.region.name
    end

  end
  def city_name
    self.city.blank? ? '' : self.city.name
  end

  def format_type
   _w =  WebSiteMediaReporter::FORMATS.find{|x| x[1]== self.format_id}
    _w.blank? ? '' : _w[0]
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
    format = Spreadsheet::Format.new(:color => :black,:horizontal_align => :center,:pattern_fg_color=>'silver',:pattern=>1, :size => 10,:border_color=>:black,:border=>:thin)

    sheet1.row(0).default_format = format
    sheet1.row(0).replace ['编号','区域','省份','城市','媒体介质','媒体名称','媒体级别','姓名','性别','部门名称','职务名称','电话','手机','邮箱','即时通讯','微博','办公地址','从业情况','生日','身份证号','籍贯','已婚？','是否有子女（性别）','是否有车（品牌）','其他（个人兴趣，爱好）','活动记录','维护记录','备注','创建时间','创建人','更新时间','更新人']
    unless data.blank?
      data.each_with_index do |d,i|
        attr = [(i+1).to_s,d.region_name,d.province_name,d.city_name,d.format_type]
        WebSiteMediaReporter::ATTR.each do |a|
          if a=='married'
            if d[a].blank?
              attr << ''
            else
              attr << (d[a]==false ? '未婚' : '已婚')
            end

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
    _media_name1,_office_address1,_city='',"",nil
    error_numbers = []
    ActiveRecord::Base.transaction do
      _sheet.each_with_index do |row,index|
        next if index==0
        _reporter = WebSiteMediaReporter.new()
        # _region_name = row[0].to_s.strip
        # _region = Region.where("name like ?","%#{_region_name}%").first
        # if _region.blank?
        #   raise ActiveRecord::Rollback
        #   break
        # end
        #_reporter.region_id=_region.id

        # _province_name = row[1].to_s.strip
        # _province = Province.where("name like ?","%#{_province_name}%").first
        # if _province.blank?
        #   raise ActiveRecord::Rollback
        #   break
        # end
        # _reporter.province_id=_province.id
        # _reporter.region_id=_city.province.region_id

        #_city_name = row[2].to_s.strip
        if row[1].to_s.strip=='分站'
          _reporter.is_substation = 1
        end
        _city = City.where("name like ?","%#{row[3].to_s.strip}%").first unless row[3].to_s.strip.blank?
        # if _city.blank?
        #   raise ActiveRecord::Rollback
        #   break
        # end
        if !_city.blank?
          _reporter.city_id=_city.id
          _reporter.province_id=_city.province_id
          _reporter.region_id=_city.province.region_id
        else
          _province = Province.where("name like ?","%#{row[2].to_s.strip}%").first unless row[3].to_s.strip.blank?
          if !_province.blank?
            _reporter.province_id=_province.id
            _reporter.region_id=_province.region_id
          end
        end

        _format = WebSiteMediaReporter::FORMATS.find{|x|x[0]==row[4].to_s.strip()}
        _reporter.format_id=_format[1] if _format


        _media_name1 = row[5].to_s unless row[5].to_s.strip == ""
        _reporter.media_name=_media_name1

        _reporter.level=row[6]
        _reporter.name=row[7]
        _reporter.sex=row[8].to_s.to_i ==0 ? '女' : '男'
        _reporter.department_name=row[9]
        _reporter.job_name=row[10]
        _reporter.telephone=row[11]
        _reporter.mobile=row[12]
        _reporter.email=row[13]
        _reporter.instant_messaging=row[14]
        _reporter.micro_blog=row[15]

        _office_address1 = row[16].to_s unless row[16].to_s.strip == ""
        _reporter.office_address=_office_address1


        _reporter.working_conditions=row[17]
        _reporter.birthday=row[18].to_s
        _reporter.id_number=row[19]
        _reporter.origin_place=row[20]

        if row[21].to_s.strip.blank?
          _reporter.married=nil
        else
          _reporter.married=row[21].to_s.strip=='未婚' ? false : true
        end

        _reporter.has_children=row[22]
        _reporter.has_car=row[23]
        _reporter.other_about=row[24]
        _reporter.active_record=row[25]
        _reporter.maintenance_record=row[26]
        _reporter.notes=row[27]

        _reporter.created_at=Time.now
        _reporter.updated_at=Time.now
        _reporter.created_by=user.id
        _reporter.updated_by=user.id
        _reporter.save
        pp "------------------------"+index.to_s
      end
      if error_numbers.count > 0
        raise ActiveRecord::Rollback
      end
    end
    error_numbers
  end


end





























