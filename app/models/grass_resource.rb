class GrassResource < ActiveRecord::Base
  attr_accessible :nickname, :media_url, :fans_number, :category, :regional, :content_location,:type_id, :media_type_id,:created_by,:read_count,:trade,:partnership,:level,:contact_name,:contact_way
  belongs_to :created_man, :class_name => "User", :foreign_key => "created_by"
  belongs_to :updated_man, :class_name => "User", :foreign_key => "updated_by"
  TYPE=[['时尚',1],['汽车',2]]
  MEDIA_TYPE=[['微信',1],['微博',2],['博客',3]]
  # validates :type_id, presence:{message:'类别不能为空'}
  # validates :media_type_id, presence:{message:'媒体不能为空'}
  # validates :nickname, presence:{message:'昵称不能为空'}
  # validates :media_url, presence:{message:'地址不能为空'}
  # validates :fans_number, presence:{message:'粉丝数不能为空'}



  def other_valid?
    errors.size == 0
  end

  def level_info
    info = ''
    if self.level.to_i>0
      (0..self.level).each do |x|
        info +='★'
      end
    end
    info
  end

  def created_name
    self.created_man.blank? ? '' : self.created_man.name
  end

  def updated_name
    self.updated_man.blank? ? '' : self.updated_man.name
  end

  def type_name
    _type = GrassResource::TYPE.find{|x| x[1] == self.type_id.to_i}
    _type.blank? ? '' : _type[0]
    # _type_name += _type[0] + '-草根资源' if _type
    # _media_type = GrassResource::MEDIA_TYPE.find{|x| x[1] == self.media_type_id.to_i}
    # _type_name += '('+_media_type[0]+')' if _media_type
    # _type_name
  end

  def media_name
    _media_type = GrassResource::MEDIA_TYPE.find{|x| x[1] == self.media_type_id.to_i}
    _media_type.blank? ? '' : _media_type[0]
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
      (0..8).each do |i|
        sheet1.row(0).set_format(i,format)
      end

      #sheet1.row(0).default_format = format
      sheet1.row(0).replace ['ID','类别','媒体','昵称','地址','粉丝','地区','内容定位','报价']
      sheet1.row(1).set_format(9,Spreadsheet::Format.new(:color => :red))
      sheet1.row(1)[9]='由于excel与系统中表格结构有所不同，因此填写数据时请按照提示进行填写，资源类别与媒体类别请从下方粘贴'
      sheet1.row(2).set_format(9,Spreadsheet::Format.new(:color => :red))
      sheet1.row(2)[9]='ID是记录的唯一标识，如果填写则是对该条记录进行修改，不填写则视为新增一条新纪录。'
      sheet1.row(3)[9]='类别包括：   '+ GrassResource::TYPE.map{|x|x[0]}.join('、')
      sheet1.row(4)[9]='媒体包括：   '+ GrassResource::MEDIA_TYPE.map{|x|x[0]}.join('、')
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
        sheet1.merge_cells(0, 0, 0, 7)
        GrassResource::MEDIA_TYPE.each do |m|
          #sheet1.row(_index).default_format = format
          sheet1.row(_index).set_format(0,Spreadsheet::Format.new(:color => :black,:horizontal_align => :center,:pattern_fg_color=>'silver',:pattern=>1, :size => 12,:border_color=>:black,:border=>:thin,:right_color=>:black,:left_color=>:black))
          sheet1.row(_index).replace [m[0]]
          sheet1.merge_cells(_index, 0, _index, 7)
          #sheet1.row(_index+1).default_format = format
          (0..7).each do |i|
            sheet1.row(_index+1).set_format(i,Spreadsheet::Format.new(:color => :black,:horizontal_align => :center,:pattern_fg_color=>'silver',:pattern=>0, :size => 10,:border_color=>:black,:border=>:thin))
          end
          sheet1.row(_index+1).replace ['ID','昵称','地址','粉丝','类别','地区','内容定位','报价']
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
              sheet1.row(_index+i).set_format(7,Spreadsheet::Format.new(:italic=>false, :text_wrap=>true,:color => :black,:horizontal_align => :left,:pattern_fg_color=>'silver',:pattern=>0, :size => 10,:right_color=>:black,:left_color=>:black,:border=>:thin))

              sheet1.row(i+_index).replace [d.id.to_s,
                                            d.nickname,
                                            d.media_url,
                                            d.fans_number,
                                            d.category,
                                            d.regional,
                                            d.content_location,
                                            d.price.to_s]

            end
            _index = _index+_item.count
          end
        end
        sheet1.row(1).set_format(0,Spreadsheet::Format.new(:color => :black,:horizontal_align => :center,:pattern_fg_color=>'silver',:pattern=>1, :size => 10,:border_color=>:black,:border=>:thin))
        sheet1.row(1).replace [item_info]
        sheet1.merge_cells(1, 0, 1, 7)
      end

      new_file = temp_folder_name + "媒体资源库-草根资源.xls"
    end

    File.delete(new_file) if File.exist?(new_file)
    workbook.write new_file
    new_file
  end

  def self.create_by_excel(_sheet=nil,user=nil,_type_id=1)
    _error_info = ''
    _error_info = '上传文件错误，请重新上传！' if _sheet.nil? or user.nil?

    ActiveRecord::Base.transaction do
      _sheet.each_with_index do |row,index|
        if _type_id==1
          next if index==0
          next if index==1
          next if index==2
          next if index==3
          next if index==4
        elsif _type_id==2
          next if index==0
          next if index==1
        end


        break if row.blank?

        if row[0].to_s.strip.blank?
          _data = GrassResource.new({:created_by=>user.id,:type_id => _type_id})
        else
          _data = GrassResource.find_by_id(row[0].to_s.to_i)
          if _data.blank?
            _error_info = 'ID错误，在第'+(index+1).to_s+'行'
            break
          end
        end

        if row[1].to_s.strip.blank?
          _error_info = '昵称不能为空！，在第'+(index+1).to_s+'行'
          break
        else
          _data.nickname = row[1].to_s
        end


        _data.media_url = row[2].to_s
        _data.fans_number = row[3].to_s.to_i
        if _type_id==1
          _data.read_count = row[4].to_s.to_i
          _data.trade = row[5].to_s.strip
          _data.category = row[6].to_s.strip
          _data.regional = row[7].to_s.strip
          _data.partnership = row[8].to_s.strip

          _data.level = row[9].to_s.strip.gsub(' ','').size
          _data.content_location = row[10].to_s.strip
          _data.contact_name = row[11].to_s.strip
          _data.contact_way = row[12].to_s.strip
          _data.price = row[13].to_s.strip.to_i unless row[13].to_s.strip.blank?
        elsif _type_id==2
          _data.trade = row[4].to_s.strip
          _data.category = row[5].to_s.strip
          _data.regional = row[6].to_s.strip
          _data.partnership = row[7].to_s.strip

          _data.level = row[8].to_s.strip.gsub(' ','').size
          _data.content_location = row[9].to_s.strip
          _data.contact_name = row[10].to_s.strip
          _data.contact_way = row[11].to_s.strip
          _data.price = row[12].to_s.strip.to_i unless row[12].to_s.strip.blank?
          _data.out_price = row[13].to_s.strip
          _data.notes = row[14].to_s.strip
        end


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
