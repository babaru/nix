class CreateTravelingPhotographyMediaInfos < ActiveRecord::Migration
  def change
    create_table :traveling_photography_media_infos do |t|
      t.string :web_site
      t.string :web_site_introduction #网站介绍
      t.string :content_name #联系人
      t.string :position #职位
      t.string :mobile
      t.string :email
      t.string :address
      t.float :coverage
      t.integer :man
      t.integer :woman
      t.text :notes
      t.integer :updated_by
      t.integer :created_by
      t.integer :deleted,:limit=>2,:default=>0 #是否已经删除1已经删除0未删除
      t.timestamps
    end
    add_index :traveling_photography_media_infos,:updated_by
    add_index :traveling_photography_media_infos,:created_by
    add_index :traveling_photography_media_infos,:web_site
    add_index :traveling_photography_media_infos,:coverage
    add_index :traveling_photography_media_infos,:deleted
  end
end
