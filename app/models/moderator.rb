class Moderator < ActiveRecord::Base
  attr_accessible :media_name,:brand_name,:product_name,:name,:sex,:position,:age,:mobile,:email,:weixin,:office_address,:id_number,:birthday,:working_conditions,:active_record ,:maintenance_record ,:topic_of_concern,:married ,:has_children,:has_car ,:other_about,:notes,:deleted,:created_by,:updated_by
  belongs_to :created_man, :class_name => "User", :foreign_key => "created_by"
  belongs_to :updated_man, :class_name => "User", :foreign_key => "updated_by"


 def other_valid?
   errors.size==0
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

    sheet1 = workbook.create_worksheet(:name => '版主信息')
    format = Spreadsheet::Format.new(:color => :black,:horizontal_align => :center,:pattern_fg_color=>'silver',:pattern=>1, :size => 10,:border_color=>:black,:border=>:thin)
    sheet1.row(0).default_format = format
    sheet1.row(0).replace ['ID','媒体名称','品牌','产品','姓名','昵称','性别','职位','年龄','手机','邮箱','QQ','办公地址','身份证号','生日','从业情况','活动记录','维护记录','关注话题','已婚？','是否有子女（性别）','是否有车（品牌）','其他（个人兴趣，爱好）','备注','创建时间','创建人','更新时间','更新人']
    [1,2,4,6,7,13,14].each do |index|
      sheet1.row(0).set_format(index,Spreadsheet::Format.new(:color => :red,:horizontal_align => :center,:pattern_fg_color=>'silver',:pattern=>1, :size => 10,:border_color=>:black,:border=>:thin))
    end
    [9,10,11].each do |index|
      sheet1.row(0).set_format(index,Spreadsheet::Format.new(:color => :blue,:horizontal_align => :center,:pattern_fg_color=>'silver',:pattern=>1, :size => 10,:border_color=>:black,:border=>:thin))
    end
    sheet2 = workbook.create_worksheet(:name => '版主信息Excel说明')
    sheet2.row(0).replace ["1.下载的网络意见领袖、博主信息列表可以直接进行上传，其中如果填写ID则表示对该条已有数据进行修改，如果没有填写ID则代表是增加一条新的供应商记录。"]
    sheet2.row(1).replace ["2.\"创建时间\",\"创建人\",\"更新时间\",\"更新人\"四项系统会自动生成，可不用填写。"]
    sheet2.row(2).replace ['3.下载版主信息Excel是根据你所提供的查询条件，如果想下载全部供应商则请去掉所有查询条件。']
    sheet2.row(3).replace ['4.如有其他问题请联系 于洋(创意部) QQ:234016483 电话:18641013958']
    sheet2.row(4).replace ["5.上传数据库请注意，红字为必填项，必须填写，蓝色项中必须填写一项。"]

    unless data.blank?
      data.each_with_index do |d,i|

        sheet1.row(i+1).replace [d.id.to_s,
                                 d.media_name,
                                 d.brand_name,
                                 d.product_name,
                                 d.name,
                                 d.nickname,
                                 (d.sex.to_i==0 ? '女' : '男'),
                                 d.position,
                                 d.age,
                                 d.mobile,
                                 d.email,
                                 d.qq,
                                 d.office_address,
                                 d.id_number,
                                 (d.birthday.blank? ? '' : d.birthday.strftime('%Y-%m-%d')),
                                 d.working_conditions,
                                 d.active_record,
                                 d.maintenance_record,
                                 d.topic_of_concern,
                                 d.married.blank? ? '' : (d.married==true ? '已婚' : '未婚'),
                                 d.has_children,
                                 d.has_car,
                                 d.other_about,
                                 d.notes,
                                 d.created_at.strftime('%Y-%m-%d'),
                                 d.created_name,
                                 d.updated_at.strftime('%Y-%m-%d'),
                                 d.updated_name]
      end
    end

    new_file = temp_folder_name + "媒体资源库-版主信息.xls"
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
        _data = Moderator.new()
        _data.media_name = row[1]
        _data.brand_name = row[2]
        _data.product_name = row[3]
        _data.name = row[4]
        _data.nickname = row[5]
        unless row[6].blank?
          _data.sex = (row[6].strip=='男' ? 1 : 0)
        end

        _data.position = row[7]
        _data.age = row[8]
        _data.mobile = row[9]
        _data.email = row[10]
        _data.office_address = row[11]
        _data.id_number = row[12]
        _data.birthday = row[13].to_s.strip.to_datetime
        _data.working_conditions = row[14]
        _data.active_record = row[15]
        _data.maintenance_record = row[16]
        _data.topic_of_concern = row[17]
        unless row[18].blank?
          _data.married = (row[18].to_s.strip=='已婚' or row[18].to_s.strip=='已') ? true : false
        end

        _data.has_children = row[19]
        _data.has_car = row[20]
        _data.other_about = row[21]
        _data.notes = row[22]

        _data.created_at=Time.now
        _data.updated_at=Time.now
        _data.created_by=user.id
        _data.updated_by=user.id
        _data.deleted=0
        msg =  _data.save
      end
    end
    return msg
  end
end
