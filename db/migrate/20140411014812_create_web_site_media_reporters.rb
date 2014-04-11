class CreateWebSiteMediaReporters < ActiveRecord::Migration
  def change
    create_table :web_site_media_reporters do |t|
     t.integer :region_id
     t.integer :province_id
     t.integer :city_id
     t.integer :format_id #媒体介质
     t.string :media_name
     t.string :level
     t.string :name
     t.integer :sex,:limit=>2  #性别1男0女
     t.string :department_name #部门名称
     t.string :job_name #职务名称
     t.string :telephone #电话
     t.string :mobile
     t.string :email
     t.string :instant_messaging #即时通讯
     t.string :micro_blog  #微博
     t.string :micro_message  #威信
     t.string :office_address #办公地址

     t.string :working_conditions  #从业情况
     t.string :birthday  #生日
     t.string :id_number #身份证号
     t.string :origin_place  #籍贯
     t.boolean :married #已婚？true已婚false未婚
     t.string :has_children #是否有子女（性别）
     t.string :has_car #是否有车（品牌）
     t.string :other_about #其他（个人兴趣，爱好）
     t.string :active_record #活动记录
     t.string :maintenance_record #维护记录
     t.text :notes
     t.integer :created_by
     t.integer :updated_by
     t.integer :deleted,:limit=>2,:default=>0 #是否已经删除1已经删除0未删除
     t.timestamps
    end
    add_index :web_site_media_reporters,:region_id
    add_index :web_site_media_reporters,:province_id
    add_index :web_site_media_reporters,:city_id
    add_index :web_site_media_reporters,:format_id
    add_index :web_site_media_reporters,:sex
    add_index :web_site_media_reporters,:created_by
    add_index :web_site_media_reporters,:updated_by
  end
end
