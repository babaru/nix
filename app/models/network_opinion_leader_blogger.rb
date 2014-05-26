class NetworkOpinionLeaderBlogger < ActiveRecord::Base
  attr_accessible :city_id,:sex,:notes,:nickname,:media_name ,:position ,:mobile ,:email ,:id_number ,:birthday,:working_conditions ,:blog_traffic ,:blog_address ,:weixin ,:active_record ,:maintenance_record ,:blog_style ,:friendly_brand ,:estranged_brand ,:nickname ,:name
  belongs_to :city
  belongs_to :created_man, :class_name => "User", :foreign_key => "created_by"
  belongs_to :updated_man, :class_name => "User", :foreign_key => "updated_by"
  # validates :nickname, presence: true
  # validates :name, presence: true
  # validates :media_name, presence: true
  # validates :position, presence: true
  # validates :mobile, presence: true
  # validates :email, presence: true
  # validates :id_number, presence: true
  # validates :birthday, presence: true
  # validates :working_conditions, presence: true
  # validates :blog_traffic, presence: true
  # validates :blog_address, presence: true
  # validates :weixin, presence: true
  # validates :blog_style, presence: true

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

    sheet1 = workbook.create_worksheet(:name => '网络意见领袖、博主信息')
    format = Spreadsheet::Format.new(:color => :black,:horizontal_align => :center,:pattern_fg_color=>'silver',:pattern=>1, :size => 10,:border_color=>:black,:border=>:thin)
    sheet1.row(0).default_format = format
    sheet1.row(0).replace ['序号','所属城市','昵称','姓名','性别','媒体','职位','电话','邮箱','身份证号','生日','从业情况','博客访问量','博客地址','微信','活动记录','维护记录','文风','友好品牌','疏远品牌','备注','创建时间','创建人','更新时间','更新人']

    unless data.blank?
      data.each_with_index do |d,i|

        sheet1.row(i+1).replace [i+1,
                                 d.city_name,
                                 d.nickname,
                                 d.name,
                                 (d.sex.to_i==0 ? '女' : '男'),
                                 d.media_name,
                                 d.position,
                                 d.mobile,
                                 d.email,
                                 d.id_number,
                                 (d.birthday.blank? ? '' : d.birthday.strftime('%Y-%m-%d')),
                                 d.working_conditions,
                                 (d.blog_traffic.blank? ? '' : d.blog_traffic.to_s+'万'),
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
    return false if _sheet.nil? or user.nil?
    ActiveRecord::Base.transaction do
      _sheet.each_with_index do |row,index|
        next if index==0
        return if row[0].blank?
        _data = NetworkOpinionLeaderBlogger.new()
        _city_name = row[1].to_s.strip

        unless _city_name.blank?
          _city = City.where("name like ?","%#{_city_name}%").first
          unless _city.blank?
            _data.city_id = _city.id
          end
        end


        _data.nickname = row[2]
        _data.name = row[3]
        if row[4].blank?
          _data.sex = nil
        else
          _data.sex= (row[4].strip=='男' ? 1 : 0)
        end

        _data.media_name = row[5]
        _data.position = row[6]
        _data.mobile = row[7]
        _data.email = row[8]
        _data.id_number = row[9]
        _data.birthday = row[10].to_s.strip.to_datetime
        _data.working_conditions = row[11]
        _data.blog_traffic = row[12]
        _data.blog_address = row[13]
        _data.web_url = row[14]
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
    end
  end
end