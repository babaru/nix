class CreateGrassResources < ActiveRecord::Migration
  def change
    create_table :grass_resources do |t|
      t.string :nickname #昵称
      t.string :media_url #地址
      t.integer :fans_number #粉丝数量
      t.string :category #类别
      t.string :regional #区域
      t.integer :type_id #资源类别
      t.text :content_location #内容定位
      t.integer :media_type_id #媒体类别
      t.integer :created_by
      t.integer :updated_by
      t.integer :deleted,:limit=>2
      t.timestamps
    end
  end
end
