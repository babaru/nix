class TravelingPhotographyMediaInfo < ActiveRecord::Base
  attr_accessible :web_site,  :web_site_introduction,  :content_name,  :position,  :mobile,  :email,  :address,  :coverage,:notes,:sex,:man, :woman,:qq
  belongs_to :created_man, :class_name => "User", :foreign_key => "created_by"
  belongs_to :updated_man, :class_name => "User", :foreign_key => "updated_by"
  validates :web_site, presence: {message:'网站不能为空！'}
  validates :web_site_introduction, presence: {message:'网站介绍不能为空！'}
  validates :content_name, presence: {message:'联系人不能为空！'}
  validates :position, presence: {message:'职位不能为空！'}
  validates :address, presence: {message:'地址不能为空！'}
  validates :coverage, presence: {message:'日均覆盖人数不能为空！'}
  validates :man, presence: {message:'日均覆盖人数(男)不能为空！'}
  validates :woman, presence: {message:'日均覆盖人数(女)不能为空！'}
  validates :woman, numericality: { greater_than: 0 }
  validates :man, numericality: { greater_than: 0 }
  validates :coverage, numericality: { greater_than: 0 }

  def other_valid?
    if self.mobile.blank? and self.qq.blank? and self.email.blank?
      errors.add(:mobile,"3种联系方式不能同时为空！")
      errors.add(:qq,"3种联系方式不能同时为空！")
      errors.add(:email,"3种联系方式不能同时为空！")
    end
    if (self.man.to_f+self.woman.to_f)>self.coverage.to_f
      errors.add(:man,"日均覆盖人数男女综合不能超过日均覆盖总人数！")
      errors.add(:woman,"日均覆盖人数男女综合不能超过日均覆盖总人数！")
    end
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

    sheet1 = workbook.create_worksheet(:name => '旅游摄影媒体信息')
    format = Spreadsheet::Format.new(:color => :black,:horizontal_align => :center,:pattern_fg_color=>'silver',:pattern=>1, :size => 10,:border_color=>:black,:border=>:thin)
    sheet1.row(0).default_format = format
    sheet1.row(0).replace ['ID','网站','网站介绍 ','联系人 ','职位 ','电话 ','邮箱 ','QQ','地址 ','日均覆盖人数(万人) ','男','女','备注 ','创建时间 ','创建人 ','更新时间 ','创建人']
    [2,3,4,8,9,10,11].each do |index|
      sheet1.row(0).set_format(index,Spreadsheet::Format.new(:color => :red,:horizontal_align => :center,:pattern_fg_color=>'silver',:pattern=>1, :size => 10,:border_color=>:black,:border=>:thin))
    end
    [5,6,7].each do |index|
      sheet1.row(0).set_format(index,Spreadsheet::Format.new(:color => :blue,:horizontal_align => :center,:pattern_fg_color=>'silver',:pattern=>1, :size => 10,:border_color=>:black,:border=>:thin))
    end
    sheet2 = workbook.create_worksheet(:name => '旅游摄影媒体Excel说明')
    sheet2.row(0).replace ["1.下载的时尚媒体信息列表可以直接进行上传，其中如果填写ID则表示对该条已有数据进行修改，如果没有填写ID则代表是增加一条新的供应商记录。"]
    sheet2.row(1).replace ["2.\"创建时间\",\"创建人\",\"更新时间\",\"更新人\"四项系统会自动生成，可不用填写。"]
    sheet2.row(2).replace ['3.下载旅游/摄影媒体Excel是根据你所提供的查询条件，如果想下载全部供应商则请去掉所有查询条件。']
    sheet2.row(3).replace ['4.如有其他问题请联系 于洋(创意部) QQ:234016483 电话:18641013958']
    sheet2.row(4).replace ["5.上传数据库请注意，红字为必填项，必须填写，蓝色项中必须填写一项。"]
    unless data.blank?
      data.each_with_index do |d,i|

        sheet1.row(i+1).replace [d.id.to_s,
                                 d.web_site,
                                 d.web_site_introduction,
                                 d.content_name,
                                 d.position,
                                 d.mobile,
                                 d.email,
                                 d.qq,
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
    _error_info = ''
    _error_info = '上传文件错误，请重新上传！' if _sheet.nil? or user.nil?
    ActiveRecord::Base.transaction do
      _sheet.each_with_index do |row,index|
        next if index==0
        break if row.blank?
        if row[0].to_s.strip.blank?
          _data = TravelingPhotographyMediaInfo.new()
        else
          _data = TravelingPhotographyMediaInfo.find_by_id(row[0].to_s.to_i)
          if _data.blank?
            _error_info = 'ID错误，在第'+index.to_s+'行' if _data.blank?
            break
          end
        end

        if row[1].to_s.strip.blank?
          _error_info = '网站不能为空！，在第'+index.to_s+'行'
          break
        else
          _data.web_site = row[1].to_s.strip
        end

        if row[2].to_s.strip.blank?
          _error_info = '网站介绍不能为空！，在第'+index.to_s+'行'
          break
        else
          _data.web_site_introduction = row[2].to_s.strip
        end

        if row[3].to_s.strip.blank?
          _error_info = '联系人不能为空！，在第'+index.to_s+'行'
          break
        else
          _data.content_name = row[3].to_s.strip
        end

        if row[4].to_s.strip.blank?
          _error_info = '职位不能为空！，在第'+index.to_s+'行'
          break
        else
          _data.position = row[4].to_s.strip
        end

        if row[5].to_s.strip.blank? and row[6].to_s.strip.blank? and row[7].to_s.strip.blank?
          _error_info = '电话，QQ，Email 不能同时为空！，在第'+index.to_s+'行'
          break
        else
          _data.mobile = row[5].to_s.strip
          _data.email = row[6].to_s.strip
          _data.qq = row[7].to_s.strip
        end

        if row[8].to_s.strip.blank?
          _error_info = '地址不能为空！，在第'+index.to_s+'行'
          break
        else
          _data.address = row[8].to_s.strip
        end

        if row[9].to_s.strip.blank?
          _error_info = '日均覆盖人数不能为空！，在第'+index.to_s+'行'
          break
        else
          _data.coverage = row[9].to_s.strip
        end

        if row[10].to_s.strip.blank?
          _error_info = '日均覆盖人数（男）不能为空！，在第'+index.to_s+'行'
          break
        else
          _data.man = row[10].to_s.strip
        end

        if row[11].to_s.strip.blank?
          _error_info = '日均覆盖人数（女）不能为空！，在第'+index.to_s+'行'
          break
        else
          _data.woman = row[11].to_s.strip
        end

        if (row[11].to_f+row[10].to_f)>row[9].to_f
          _error_info = '日均覆盖男人数与女人数之和不能大于日均覆盖人数！，在第'+index.to_s+'行'
          break
        end

        _data.notes=row[12]

        _data.created_at=Time.now
        _data.updated_at=Time.now
        _data.created_by=user.id
        _data.updated_by=user.id
        _data.deleted=0
        _data.save

      end
      if _error_info != ''
        raise ActiveRecord::Rollback
      end
    end
    _error_info
  end
end
