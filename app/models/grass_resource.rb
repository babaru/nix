class GrassResource < ActiveRecord::Base
  attr_accessible :nickname, :media_url, :fans_number, :category, :regional, :content_location,:type_id, :media_type_id
  belongs_to :created_man, :class_name => "User", :foreign_key => "created_by"
  belongs_to :updated_man, :class_name => "User", :foreign_key => "updated_by"
  TYPE=[['时尚',1],['汽车',2]]
  MEDIA_TYPE=[['微信',1],['微博',2],['博客',3]]



  def other_valid?
    errors.size == 0
  end

  def created_name
    self.created_man.blank? ? '' : self.created_man.name
  end

  def updated_name
    self.updated_man.blank? ? '' : self.updated_man.name
  end

  def type_name
    _type_name = ''
    _type = GrassResource::TYPE.find{|x| x[1] == self.type_id.to_i}
    _type_name += _type[0] + '-草根资源' if _type
    _media_type = GrassResource::MEDIA_TYPE.find{|x| x[1] == self.media_type_id.to_i}
    _type_name += '('+_media_type[0]+')' if _media_type
    _type_name
  end

  def self.create_new_template(data=nil)
    temp_folder_name = Rails.root.to_s + "/public/temp/"
    unless File.exist?(temp_folder_name)
      FileUtils.mkdir_p(temp_folder_name)
    end
    FileUtils.rm Dir[temp_folder_name.to_s+'*.xls']
    require "spreadsheet"
    workbook = Spreadsheet::Workbook.new
    format = Spreadsheet::Format.new(:pattern => 1,:color => :white, :weight => :bold, :size => 11,:horizontal_align => :center)
    if data==nil
      sheet1 = workbook.create_worksheet(:name => '草根资源上传模板')
      sheet1.row(0).default_format = format
      sheet1.row(0).replace ['资源类别','媒体类别','昵称','地址','粉丝','类别','地区','内容定位']
      sheet1.row(1).set_format(8,Spreadsheet::Format.new(:color => :red))
      sheet1.row(1)[8]='由于excel与系统中表格结构有所不同，因此填写数据时请按照提示进行填写，资源类别与媒体类别请从下方粘贴'
      sheet1.row(2)[8]='资源类别包括：   '+ GrassResource::TYPE.map{|x|x[0]}.join('、')
      sheet1.row(3)[8]='媒体类别包括：   '+ GrassResource::MEDIA_TYPE.map{|x|x[0]}.join('、')
      new_file = temp_folder_name + "媒体资源库-草根资源上传模板.xls"
    else
      GrassResource::TYPE.each do |t|
        sheet1 = workbook.create_worksheet(:name => t[0]+'-草根资源列表')
        _index=0
        GrassResource::MEDIA_TYPE.each do |m|
          sheet1.row(_index).default_format = format
          sheet1.row(_index).replace [m[0]]
          sheet1.row(_index).height = 18
          sheet1.merge_cells(_index, 0, _index, 6)
          sheet1.row(_index+1).default_format = format
          sheet1.row(_index+1).replace ['昵称','地址','粉丝','类别','地区','内容定位']
          sheet1.row(_index+1).height = 18
          _index = _index+2
          _item = data.select{|x|x.type_id.to_i==t[1] and x.media_type_id==m[1]}
          unless _item.blank?
            _item.each_with_index do |d,i|

              sheet1.row(i+_index).replace [d.nickname,
                                            d.media_url,
                                            d.fans_number,
                                            d.category,
                                            d.regional,
                                            d.content_location]
              _index = _index+1
            end
          end
        end
      end

      new_file = temp_folder_name + "媒体资源库-草根资源.xls"
    end

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
        _data = GrassResource.new()
        _type_name = row[0].strip
        _type= GrassResource::TYPE.find{|x| x[0]==_type_name}
        if _type.blank?
          raise ActiveRecord::Rollback
          break
        end
        _data.type_id = _type[1]

        _media_type_name = row[1].strip
        _media_type= GrassResource::MEDIA_TYPE.find{|x| x[0]==_media_type_name}
        if _media_type.blank?
          raise ActiveRecord::Rollback
          break
        end
        _data.media_type_id = _media_type[1]

        _data.nickname = row[2]
        _data.media_url = row[3]
        _data.fans_number = row[4]
        _data.category = row[5]
        _data.regional = row[6]
        _data.content_location = row[7]


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
