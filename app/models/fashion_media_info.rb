class FashionMediaInfo < ActiveRecord::Base
  attr_accessible :web_site,  :web_site_introduction,  :content_name,  :position,  :mobile,  :email,  :weixin,  :address,  :coverage, :city_id,:notes,:sex
  belongs_to :city
  belongs_to :created_man, :class_name => "User", :foreign_key => "created_by"
  belongs_to :updated_man, :class_name => "User", :foreign_key => "updated_by"
  validates :web_site, presence: true
  validates :web_site_introduction, presence: true
  validates :content_name, presence: true
  validates :position, presence: true
  validates :mobile, presence: true
  validates :email, presence: true
  validates :weixin, presence: true
  validates :address, presence: true
  validates :coverage, presence: true

  def other_valid?
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

    sheet1 = workbook.create_worksheet(:name => '时尚媒体信息')
    format = Spreadsheet::Format.new(:pattern => 1,:color => :white, :weight => :bold, :size => 11)
    sheet1.row(0).default_format = format
    sheet1.row(0).replace ['所属城市 ','网站地址 ','网站介绍 ','联系人 ','职位 ','电话 ','邮箱 ','微信 ','地址 ','日均覆盖人数(万人) ','性别 ','备注 ','创建时间 ','创建人 ','更新时间 ','创建人']
    sheet1.row(0).height = 18
    unless data.blank?
      data.each_with_index do |d,i|

        sheet1.row(i+1).replace [d.city_name,
                                 d.web_site,
                                 d.web_site_introduction,
                                 d.content_name,
                                 d.position,
                                 d.mobile,
                                 d.email,
                                 d.weixin,
                                 d.address,
                                 d.coverage,
                                 (d.sex.to_i==0 ? '女' : '男'),
                                 d.notes,
                                 d.created_at.strftime('%Y-%m-%d'),
                                 d.created_name,
                                 d.updated_at.strftime('%Y-%m-%d'),
                                 d.updated_name]
      end
    end

    new_file = temp_folder_name + "媒体资源库-时尚媒体信息.xls"
    File.delete(new_file) if File.exist?(new_file)
    workbook.write new_file
    new_file
  end

  def self.create_by_excel(_sheet=nil,user=nil)
    return false if _sheet.nil? or user.nil?
    msg = false
    ActiveRecord::Base.transaction do
      _sheet.each_with_index do |row,index|
        next if index==0
        _data = FashionMediaInfo.new()
        _city_name = row[0].strip

        _city = City.where("name like ?","%#{_city_name}%").first
        if _city.blank?
          raise ActiveRecord::Rollback
          break
        end
        _data.city_id=_city.id
        _data.web_site= row[1]
        _data.web_site_introduction= row[2]
        _data.content_name=row[3]
        _data.position=row[4]
        _data.mobile= row[5]
        _data.email= row[6]
        _data.weixin= row[7]
        _data.address=row[8]
        _data.coverage= row[9]
        _data.sex= (row[10].strip=='男' ? 1 : 0)
        _data.notes=row[11]

        _data.created_at=Time.now
        _data.updated_at=Time.now
        _data.created_by=user.id
        _data.updated_by=user.id
        msg =  _data.save
      end
    end
    return msg
  end
end
