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
  validates :media_name, presence:{message:'媒体名称不能为空'}
  validates :level, presence:{message:'媒体级别不能为空'}
  validates :name, presence:{message:'姓名不能为空'}
  validates :job_name, presence:{message:'职位名称不能为空'}
  validates :id_number, presence:{message:'身份证号码不能为空'}
  validates :other_about, presence:{message:'兴趣，爱好不能为空'}
  ATTR=['media_name','level','name','sex','department_name','job_name','telephone','mobile','email','instant_messaging','micro_blog','office_address','working_conditions','birthday','id_number','origin_place','married','has_children','has_car','other_about','active_record','maintenance_record']
  FORMATS=[['财经门户',1],['党政门户',2],['核心垂直',3],['核心门户',4],['论坛',5],['论坛分站',6],['论坛媒体',7],['门户分站',8],['汽车垂直',9],['汽车垂直分站',10],['区域垂直',11],['区域分站',12],['区域论坛',13],['区域媒体',14],['区域门户',15],['社区门户',16],['视频',17],['视频分站',18],['综合门户',19]]
  LEVELS = [['A','A'],['B','B'],['C','C'],['D','D'],['E','E'],['F','F'],['G','G'],['H','H'],['I','I']]

  def other_valid?
    if self.telephone.blank? and self.mobile.blank? and self.email.blank? and self.instant_messaging.blank?
      errors.add(:telephone,"4种联系方式不能同时为空")
      errors.add(:mobile,"4种联系方式不能同时为空")
      errors.add(:email,"4种联系方式不能同时为空")
      errors.add(:instant_messaging,"4种联系方式不能同时为空")
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
    sheet1.row(0).replace ['ID','区域','省份','城市','媒体介质','媒体名称','媒体级别','姓名','性别','部门名称','职务名称','电话','手机','邮箱','QQ','微博','办公地址','从业情况','生日','身份证号','籍贯','已婚？','是否有子女（性别）','是否有车（品牌）','其他（个人兴趣，爱好）','活动记录','维护记录','备注','创建时间','创建人','更新时间','更新人']
    [5,7,8,10,19,24].each do |index|
      sheet1.row(0).set_format(index,Spreadsheet::Format.new(:color => :red,:horizontal_align => :center,:pattern_fg_color=>'silver',:pattern=>1, :size => 10,:border_color=>:black,:border=>:thin))
    end
    [11,12,13,14].each do |index|
      sheet1.row(0).set_format(index,Spreadsheet::Format.new(:color => :blue,:horizontal_align => :center,:pattern_fg_color=>'silver',:pattern=>1, :size => 10,:border_color=>:black,:border=>:thin))
    end
    sheet2 = workbook.create_worksheet(:name => '记者基本信息Excel说明')
    sheet2.row(0).replace ['1.下载的记者基本信息列表可以直接进行上传，其中如果填写ID则表示对该条已有数据进行修改，如果没有填写ID则代表是增加一条新的供应商记录。']
    sheet2.row(1).replace ["2.某些涉及的内容要求一定要规范填写如 \"媒体介质\",\"媒体级别\"等，如果不确定请从页面复制粘贴。"]
    sheet2.row(2).replace ["3.上传数据库请注意，上传数据库请注意，红色项必须填写，蓝色项中必须填写一项。"]
    sheet2.row(3).replace ['4.下载记者基本信息Excel是根据你所提供的查询条件，如果想下载全部供应商则请去掉所有查询条件。']
    sheet2.row(4).replace ['5.如有其他问题请联系 于洋(创意部) QQ:234016483 电话:18641013958']
    unless data.blank?
      data.each_with_index do |d,i|
        attr = [d.id.to_s,d.region_name,d.province_name,d.city_name,d.format_type]
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
    _error_info = ''
    _error_info = '上传文件错误，请重新上传！' if _sheet.nil? or user.nil?
    ActiveRecord::Base.transaction do
      _sheet.each_with_index do |row,index|
        next if index==0
        if row[0].to_s.strip.blank?
          data = WebSiteMediaReporter.new({:created_by=>user.id})
        else
          data = WebSiteMediaReporter.find_by_id(row[0].to_s.to_i)
          if data.blank?
            _error_info = 'ID错误，在第'+index.to_s+'行' if data.blank?
            break
          end
        end

        if row[1].to_s.strip=='分站'
          data.is_substation = 1
        end


        _city = City.where("name like ?","%#{row[3].to_s.strip}%").first unless row[3].to_s.strip.blank?
        if _city.blank?
          _error_info = '城市不能为空！，在第'+index.to_s+'行'
          break
        else
          data.city_id=_city.id
          data.province_id=_city.province_id
          data.region_id=_city.province.region_id
        end

        _format = WebSiteMediaReporter::FORMATS.find{|x|x[0]==row[4].to_s.strip()}
        data.format_id=_format[1] if _format


        if row[5].to_s.strip().blank?
          _error_info = '媒体名称不能为空！，在第'+index.to_s+'行'
          break
        else
          data.media_name = row[5].to_s.strip()
        end

        data.level=row[6]

        if row[7].to_s.strip().blank?
          _error_info = '姓名不能为空！，在第'+index.to_s+'行'
          break
        else
          data.media_name = row[7].to_s.strip()
        end

        data.sex=row[8].to_s.to_i ==0 ? '女' : '男'
        data.department_name=row[9]

        if row[10].to_s.strip().blank?
          _error_info = '职位名称不能为空！，在第'+index.to_s+'行'
          break
        else
          data.media_name = row[10].to_s.strip()
        end

        if row[11].to_s.strip().blank? and row[12].to_s.strip().blank? and row[13].to_s.strip().blank? and row[14].to_s.strip().blank?
          _error_info = '4种联系方式不能同时为空！，在第'+index.to_s+'行'
          break
        else
          data.telephone=row[11]
          data.mobile=row[12]
          data.email=row[13]
          data.instant_messaging=row[14]
        end

        data.micro_blog=row[15]

        _office_address1 = row[16].to_s unless row[16].to_s.strip == ""
        data.office_address=_office_address1


        data.working_conditions=row[17]
        data.birthday=row[18].to_s

        if row[19].to_s.strip().blank?
          _error_info = '身份证号不能为空！，在第'+index.to_s+'行'
          break
        else
          data.media_name = row[19].to_s.strip()
        end

        data.origin_place=row[20]

        if row[21].to_s.strip.blank?
          data.married=nil
        else
          data.married=row[21].to_s.strip=='未婚' ? false : true
        end

        data.has_children=row[22]
        data.has_car=row[23]
        data.other_about=row[24]

        if row[24].to_s.strip().blank?
          _error_info = '其他（个人兴趣，爱好）不能为空！，在第'+index.to_s+'行'
          break
        else
          data.media_name = row[24].to_s.strip()
        end

        data.active_record=row[25]
        data.maintenance_record=row[26]
        data.notes=row[27]

        data.created_at=Time.now
        data.updated_at=Time.now
        data.created_by=user.id
        data.updated_by=user.id
        data.save
      end
      if _error_info != ''
        raise ActiveRecord::Rollback
      end
    end
    _error_info
  end


end





























