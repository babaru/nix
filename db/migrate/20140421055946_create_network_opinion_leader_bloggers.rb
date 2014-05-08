class CreateNetworkOpinionLeaderBloggers < ActiveRecord::Migration
  def change
    create_table :network_opinion_leader_bloggers do |t|
      t.integer :city_id
      t.string :nickname #昵称
      t.string :name
      t.integer :sex,:limit=>2
      t.string :media_name #媒体
      t.string :position #职位
      t.string :mobile
      t.string :email
      t.string :id_number
      t.datetime :birthday
      t.string :working_conditions
      t.integer :blog_traffic,:limit=>6
      t.string :blog_address
      t.string :web_url
      t.string :weixin
      t.string :active_record #活动记录
      t.string :maintenance_record #维护记录
      t.string :blog_style #文风
      t.string :friendly_brand #友好品牌
      t.string :estranged_brand #疏远品牌
      t.text :notes
      t.integer :updated_by
      t.integer :created_by
      t.integer :deleted,:limit=>2,:default=>0 #是否已经删除1已经删除0未删除
      t.timestamps
    end
    add_index :network_opinion_leader_bloggers,:city_id
    add_index :network_opinion_leader_bloggers,:name
    add_index :network_opinion_leader_bloggers,:weixin
    add_index :network_opinion_leader_bloggers,:deleted
    add_index :network_opinion_leader_bloggers,:updated_by
    add_index :network_opinion_leader_bloggers,:created_by
    add_index :network_opinion_leader_bloggers,:blog_style
  end
end
