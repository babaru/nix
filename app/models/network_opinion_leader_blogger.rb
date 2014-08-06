class NetworkOpinionLeaderBlogger < ActiveRecord::Base
  attr_accessible :city_id,:sex,:notes,:nickname,:media_name ,:position ,:mobile ,:email ,:id_number ,:birthday,:working_conditions ,:blog_traffic ,:blog_address ,:weixin ,:active_record ,:maintenance_record ,:blog_style ,:friendly_brand ,:estranged_brand ,:nickname ,:name
  belongs_to :city
  belongs_to :created_man, :class_name => "User", :foreign_key => "created_by"
  belongs_to :updated_man, :class_name => "User", :foreign_key => "updated_by"

  validates :nickname, presence: {message:'昵称不能为空！'}
  validates :name, presence: {message:'姓名不能为空！'}
  validates :sex, presence: {message:'性别不能为空！'}
  validates :media_name, presence: {message:'媒体不能为空！'}
  validates :position, presence: {message:'职位不能为空！'}
  validates :id_number, presence: {message:'身份证不能为空！'}
  validates :birthday, presence: {message:'生日不能为空！'}
  validates :blog_traffic, presence: {message:'博客访问量不能为空！'}
  validates :blog_traffic, numericality: { greater_than: 0 }
  validates :blog_address, presence: {message:'博客地址不能为空！'}

  def other_valid?
    if self.mobile.blank? and self.qq.blank? and self.email.blank?
      errors.add(:mobile,"3种联系方式不能同时为空！")
      errors.add(:qq,"3种联系方式不能同时为空！")
      errors.add(:email,"3种联系方式不能同时为空！")
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

    sheet1 = workbook.create_worksheet(:name => '网络意见领袖、博主信息')
    format = Spreadsheet::Format.new(:color => :black,:horizontal_align => :center,:pattern_fg_color=>'silver',:pattern=>1, :size => 10,:border_color=>:black,:border=>:thin)
    sheet1.row(0).default_format = format
    sheet1.row(0).replace ['ID','所属城市','昵称','姓名','性别','媒体','职位','电话','邮箱','QQ','身份证号','生日','从业情况','博客访问量(万)','博客地址','微信','活动记录','维护记录','文风','友好品牌','疏远品牌','备注','创建时间','创建人','更新时间','更新人']
    [2,3,4,5,6,8,10,11,13,14].each do |index|
      sheet1.row(0).set_format(index,Spreadsheet::Format.new(:color => :red,:horizontal_align => :center,:pattern_fg_color=>'silver',:pattern=>1, :size => 10,:border_color=>:black,:border=>:thin))
    end
    [7,8,9].each do |index|
      sheet1.row(0).set_format(index,Spreadsheet::Format.new(:color => :blue,:horizontal_align => :center,:pattern_fg_color=>'silver',:pattern=>1, :size => 10,:border_color=>:black,:border=>:thin))
    end
    sheet2 = workbook.create_worksheet(:name => '网络意见领袖、博主信息Excel说明')
    sheet2.row(0).replace ["1.下载的网络意见领袖、博主信息列表可以直接进行上传，其中如果填写ID则表示对该条已有数据进行修改，如果没有填写ID则代表是增加一条新的供应商记录。"]
    sheet2.row(1).replace ["2.\"创建时间\",\"创建人\",\"更新时间\",\"更新人\"四项系统会自动生成，可不用填写。"]
    sheet2.row(2).replace ['3.下载网络意见领袖、博主信息Excel是根据你所提供的查询条件，如果想下载全部供应商则请去掉所有查询条件。']
    sheet2.row(3).replace ['4.如有其他问题请联系 于洋(创意部) QQ:234016483 电话:18641013958']
    sheet2.row(4).replace ["5.上传数据库请注意，红字为必填项，必须填写，蓝色项中必须填写一项。"]
    unless data.blank?
      data.each_with_index do |d,i|

        sheet1.row(i+1).replace [d.id.to_s,
                                 d.city_name,
                                 d.nickname,
                                 d.name,
                                 (d.sex.to_i==0 ? '女' : '男'),
                                 d.media_name,
                                 d.position,
                                 d.mobile,
                                 d.email,
                                 d.qq,
                                 d.id_number,
                                 (d.birthday.blank? ? '' : d.birthday.strftime('%Y-%m-%d')),
                                 d.working_conditions,
                                 (d.blog_traffic.blank? ? '' : d.blog_traffic.to_s),
                                 d.blog_address,
                                 d.weixin,
                                 d.active_record,
                                 d.maintenance_record,
                                 d.blog_style,
                                 d.friendly_brand,
                                 d.estranged_brand,
                                 d.notes,
                                 d.created_at.strftime('%Y-%m-%d'),
                                 d.created_name,
                                 d.updated_at.strftime('%Y-%m-%d'),
                                 d.updated_name]
      end
    end

    new_file = temp_folder_name + "媒体资源库-网络意见领袖、博主信息.xls"
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
          _data = NetworkOpinionLeaderBlogger.new()
        else
          _data = NetworkOpinionLeaderBlogger.find_by_id(row[0].to_s.to_i)
          if _data.blank?
            _error_info = 'ID错误，在第'+index.to_s+'行' if _data.blank?
            break
          end
        end

        _city_name = row[1].to_s.strip
        unless _city_name.blank?
          _city = City.where("name like ?","%#{_city_name}%").first
          unless _city.blank?
            _data.city_id = _city.id
          end
        end

        if row[2].to_s.strip.blank?
          _error_info = '昵称不能为空！，在第'+index.to_s+'行'
          break
        else
          _data.nickname = row[2].to_s.strip
        end

        if row[3].to_s.strip.blank?
          _error_info = '姓名不能为空！，在第'+index.to_s+'行'
          break
        else
          _data.name = row[3].to_s.strip
        end

        if row[4].to_s.strip.blank?
          _error_info = '性别不能为空！，在第'+index.to_s+'行'
          break
        else
          _data.sex= (row[4].to_s.strip=='男' ? 1 : 0)
        end

        if row[5].to_s.strip.blank?
          _error_info = '媒体不能为空！，在第'+index.to_s+'行'
          break
        else
          _data.media_name= row[5].to_s.strip
        end

        if row[6].to_s.strip.blank?
          _error_info = '职位不能为空！，在第'+index.to_s+'行'
          break
        else
          _data.position= row[6].to_s.strip
        end

        if row[7].to_s.strip.blank? and row[8].to_s.strip.blank? and row[9].to_s.strip.blank?
          _error_info = '电话，QQ，Email 不能同时为空！，在第'+index.to_s+'行'
          break
        else
          _data.mobile = row[7].to_s.strip
          _data.email = row[8].to_s.strip
          _data.qq = row[9].to_s.strip
        end

        if row[10].to_s.strip.blank?
          _error_info = '身份证不能为空！，在第'+index.to_s+'行'
          break
        else
          _data.id_number= row[10].to_s.strip
        end

        if row[11].to_s.strip.blank?
          _error_info = '生日不能为空！，在第'+index.to_s+'行'
          break
        else
          _data.birthday= row[11].to_s.strip.to_datetime
        end

        _data.working_conditions = row[12].to_s.strip

        if row[13].to_s.strip.blank?
          _error_info = '博客访问量不能为空！，在第'+index.to_s+'行'
          break
        else
          _data.blog_traffic= row[13].to_s.strip
        end

        if row[14].to_s.strip.blank?
          _error_info = '博客地址不能为空！，在第'+index.to_s+'行'
          break
        else
          _data.blog_address= row[14].to_s.strip.to_datetime
        end

        _data.weixin = row[15]
        _data.active_record = row[16]
        _data.maintenance_record = row[17]
        _data.blog_style = row[18]
        _data.friendly_brand = row[19]
        _data.estranged_brand = row[20]
        _data.notes = row[21]

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
