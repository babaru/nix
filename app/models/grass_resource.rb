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
    format = Spreadsheet::Format.new(:color => :black,:horizontal_align => :center,:pattern_fg_color=>'silver',:pattern=>1, :size => 10,:border_color=>:black,:border=>:thin)
    if data==nil
      sheet1 = workbook.create_worksheet(:name => '草根资源上传模板')
      (0..7).each do |i|
        sheet1.row(0).set_format(i,format)
      end

      #sheet1.row(0).default_format = format
      sheet1.row(0).replace ['资源类别','媒体类别','昵称','地址','粉丝','类别','地区','内容定位']
      sheet1.row(1).set_format(8,Spreadsheet::Format.new(:color => :red))
      sheet1.row(1)[8]='由于excel与系统中表格结构有所不同，因此填写数据时请按照提示进行填写，资源类别与媒体类别请从下方粘贴'
      sheet1.row(2)[8]='资源类别包括：   '+ GrassResource::TYPE.map{|x|x[0]}.join('、')
      sheet1.row(3)[8]='媒体类别包括：   '+ GrassResource::MEDIA_TYPE.map{|x|x[0]}.join('、')
      new_file = temp_folder_name + "媒体资源库-草根资源上传模板.xls"
    else
      GrassResource::TYPE.each do |t|
        sheet1 = workbook.create_worksheet(:name => t[0]+'-草根资源表')
        _t = data.select{|x|x.type_id.to_i==t[1]}
        _t_count = _t.blank? ? 0 : _t.count
        item_info = '注:共'+_t_count.to_s+'人,其中'
        _index=2
        sheet1.row(0).set_format(0,Spreadsheet::Format.new(:color => :black,:horizontal_align => :center,:pattern_fg_color=>'silver',:pattern=>0, :size => 24,:border_color=>:black,:border=>:thin))
        sheet1.row(0).replace ['Iforce-网络媒体-草根资源']
        sheet1.row(0).height = 35
        sheet1.merge_cells(0, 0, 0, 6)
        GrassResource::MEDIA_TYPE.each do |m|
          #sheet1.row(_index).default_format = format
          sheet1.row(_index).set_format(0,Spreadsheet::Format.new(:color => :black,:horizontal_align => :center,:pattern_fg_color=>'silver',:pattern=>1, :size => 12,:border_color=>:black,:border=>:thin,:right_color=>:black,:left_color=>:black))
          sheet1.row(_index).replace [m[0]]
          sheet1.merge_cells(_index, 0, _index, 6)
          #sheet1.row(_index+1).default_format = format
          (0..6).each do |i|
            sheet1.row(_index+1).set_format(i,Spreadsheet::Format.new(:color => :black,:horizontal_align => :center,:pattern_fg_color=>'silver',:pattern=>0, :size => 10,:border_color=>:black,:border=>:thin))
          end
          sheet1.row(_index+1).replace ['序号','昵称','地址','粉丝','类别','地区','内容定位']
          #sheet1.row(_index+1).height = 18
          _index = _index+2
          _item = data.select{|x|x.type_id.to_i==t[1] and x.media_type_id==m[1]}
          _item_count =  _item.blank? ? 0 : _item.count
          item_info +=m[0].to_s+'类'+_item_count.to_s+'人;'
          unless _item.blank?
            _item.each_with_index do |d,i|
              (0..4).each do |j|
                sheet1.row(_index+i).set_format(j,Spreadsheet::Format.new(:color => :black,:horizontal_align => :center,:pattern_fg_color=>'silver',:pattern=>0, :size => 10,:right_color=>:black,:left_color=>:black,:border=>:thin))
              end
              sheet1.row(_index+i).set_format(5,Spreadsheet::Format.new(:color => :black,:horizontal_align => :left,:pattern_fg_color=>'silver',:pattern=>0, :size => 10,:right_color=>:black,:left_color=>:black,:border=>:thin))
              sheet1.row(_index+i).set_format(6,Spreadsheet::Format.new(:italic=>false, :text_wrap=>true,:color => :black,:horizontal_align => :left,:pattern_fg_color=>'silver',:pattern=>0, :size => 10,:right_color=>:black,:left_color=>:black,:border=>:thin))

              sheet1.row(i+_index).replace [i+1,
                                            d.nickname,
                                            d.media_url,
                                            d.fans_number,
                                            d.category,
                                            d.regional,
                                            d.content_location]

            end
            _index = _index+_item.count
          end
        end
        sheet1.row(1).set_format(0,Spreadsheet::Format.new(:color => :black,:horizontal_align => :center,:pattern_fg_color=>'silver',:pattern=>1, :size => 10,:border_color=>:black,:border=>:thin))
        sheet1.row(1).replace [item_info]
        sheet1.merge_cells(1, 0, 1, 6)
      end

      new_file = temp_folder_name + "媒体资源库-草根资源.xls"
    end

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
        break if row[0].to_s.strip.blank?
        _data = GrassResource.new()
        _type_name = row[0].to_s.strip
        _type= GrassResource::TYPE.find{|x| x[0]==_type_name}
        if _type.blank?
          error_numbers << (index+1).to_s
          next
        end
        _data.type_id = _type[1]

        _media_type_name = row[1].to_s.strip
        _media_type= GrassResource::MEDIA_TYPE.find{|x| x[0]==_media_type_name}
        if _media_type.blank?
          error_numbers << (index+1).to_s
          next
        end
        _data.media_type_id = _media_type[1]

        _data.nickname = row[2]
        _data.media_url = row[3]
        unless row[4].to_s.to_i==0
          _data.fans_number = row[4].to_s.to_i
        end

        _data.category = row[5]
        _data.regional = row[6]
        _data.content_location = row[7]
        _data.price = row[8] unless row[8].to_s.blank?

        _data.created_at=Time.now
        _data.updated_at=Time.now
        _data.created_by=user.id
        _data.updated_by=user.id
        _data.deleted=0
        _data.save
      end
      if error_numbers.count > 0
        raise ActiveRecord::Rollback
      end
    end
    error_numbers
  end
end
