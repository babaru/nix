class CreateFashionMediaInfos < ActiveRecord::Migration
  def change
    create_table :fashion_media_infos do |t|
      t.integer :city_id
      t.string :web_site
      t.string :web_site_introduction #网站介绍
      t.string :content_name #联系人
      t.string :position #职位
      t.string :mobile
      t.string :email
      t.string :weixin
      t.string :address
      t.float :coverage
      t.integer :sex,:limit=>2
      t.text :notes
      t.integer :updated_by
      t.integer :created_by
      t.integer :deleted,:limit=>2,:default=>0 #是否已经删除1已经删除0未删除
      t.timestamps
    end
    add_index :fashion_media_infos,:city_id
    add_index :fashion_media_infos,:updated_by
    add_index :fashion_media_infos,:created_by
    add_index :fashion_media_infos,:sex
    add_index :fashion_media_infos,:web_site
    add_index :fashion_media_infos,:coverage
    add_index :fashion_media_infos,:deleted
  end
end
