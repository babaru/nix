class WebSiteMediaReporter < ActiveRecord::Base
  attr_accessible     :region_id, :province_id, :city_id, :format_id, :media_name, :level, :name, :sex, :department_name, :job_name, :telephone, :mobile, :email, :instant_messaging, :micro_blog, :micro_message, :office_address, :working_conditions, :birthday, :id_number, :origin_place, :has_children, :has_car, :other_about, :active_record, :maintenance_record, :notes
  belongs_to :province
  belongs_to :city
  belongs_to :region
  belongs_to :created_man, :class_name => "User", :foreign_key => "created_by"
  belongs_to :updated_man, :class_name => "User", :foreign_key => "updated_by"
  ATTR=['media_name','level','name','sex','department_name','job_name','telephone','mobile','email','instant_messaging','micro_blog','micro_message','office_address','working_conditions','birthday','id_number','origin_place','married','has_children','has_car','other_about','active_record','maintenance_record','notes']


  def other_valid?
    if self.region_id.to_i==0
      errors.add(:region_id,"请选择地区")
    end
    if self.province_id.to_i==0
      errors.add(:province_id,"请选择省份")
    end
    if self.city_id.to_i==0
      errors.add(:city_id,"请选择城市")
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


end
