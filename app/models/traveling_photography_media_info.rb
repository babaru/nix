class TravelingPhotographyMediaInfo < ActiveRecord::Base
  attr_accessible :web_site,  :web_site_introduction,  :content_name,  :position,  :mobile,  :email,  :address,  :coverage,:notes,:sex
  belongs_to :created_man, :class_name => "User", :foreign_key => "created_by"
  belongs_to :updated_man, :class_name => "User", :foreign_key => "updated_by"
  # validates :web_site, presence: true
  # validates :web_site_introduction, presence: true
  # validates :content_name, presence: true
  # validates :position, presence: true
  # validates :mobile, presence: true
  # validates :email, presence: true
  # validates :address, presence: true
  # validates :coverage, presence: true

  def other_valid?
    errors.size == 0
  end

  def created_name
    self.created_man.blank? ? '' : self.created_man.name
  end
  def updated_name
    self.updated_man.blank? ? '' : self.updated_man.name
  end

  def self.create_new_template(data=nil)
    temp_folder_name = Rails.root.to_s + "/public/temp/"
    unless File.exist?(temp_folder_name)
      FileUtils.mkdir_p(temp_folder_name)
    end
    FileUtils.rm Dir[temp_folder_name.to_s+'*.xls']
    require "spreadsheet"
    workbook = Spreadsheet::Workbook.new

    sheet1 = workbook.create_worksheet(:name => '旅游/摄影媒体信息')
    format = Spreadsheet::Format.new(:color => :black,:horizontal_align => :center,:pattern_fg_color=>'silver',:pattern=>1, :size => 10,:border_color=>:black,:border=>:thin)
    sheet1.row(0).default_format = format
    sheet1.row(0).replace ['序号','网站地址 ','网站介绍 ','联系人 ','职位 ','电话 ','邮箱 ','地址 ','日均覆盖人数(万人) ','男','女','备注 ','创建时间 ','创建人 ','更新时间 ','创建人']
    unless data.blank?
      data.each_with_index do |d,i|

        sheet1.row(i+1).replace [i+1,
                                 d.web_site,
                                 d.web_site_introduction,
                                 d.content_name,
                                 d.position,
                                 d.mobile,
                                 d.email,
                                 d.address,
                                 d.coverage,
                                 d.man,
                                 d.woman,
                                 d.notes,
                                 d.created_at.strftime('%Y-%m-%d'),
                                 d.created_name,
                                 d.updated_at.strftime('%Y-%m-%d'),
                                 d.updated_name]
      end
    end

    new_file = temp_folder_name + "媒体资源库-旅游摄影媒体信息.xls"
    File.delete(new_file) if File.exist?(new_file)
    workbook.write new_file
    new_file
  end

  def self.create_by_excel(_sheet=nil,user=nil)
    return false if _sheet.nil? or user.nil?
    error_numbers = []
    ActiveRecord::Base.transaction do
      _sheet.each_with_index do |row,index|
        next if index==0
        _data = TravelingPhotographyMediaInfo.new()
        _data.web_site= row[1]
        _data.web_site_introduction= row[2]
        _data.content_name=row[3]
        _data.position=row[4]
        _data.mobile= row[5]
        _data.email= row[6]
        _data.address=row[7]
        _data.coverage= row[8]
        _data.man= (row[9].to_s=='' ? '' : row[9])
        _data.woman= (row[10].to_s.blank? ? '' : row[10])
        _data.notes=row[11]

        _data.created_at=Time.now
        _data.updated_at=Time.now
        _data.created_by=user.id
        _data.updated_by=user.id
        _data.deleted=0
        _data.save
      end
    end
    error_numbers
  end
end
