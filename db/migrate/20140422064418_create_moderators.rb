class CreateModerators < ActiveRecord::Migration
  def change
    create_table :moderators do |t|
      t.string :media_name
      t.string :brand_name
      t.string :product_name
      t.string :name
      t.integer :sex,:limit=>2
      t.string :position
      t.integer :age,:limit=>3
      t.string :mobile
      t.string :email
      t.string :weixin
      t.string :office_address
      t.string :id_number
      t.datetime :birthday
      t.string :working_conditions
      t.string :active_record #活动记录
      t.string :maintenance_record #维护记录
      t.string :topic_of_concern #关注话题
      t.boolean :married #已婚？true已婚false未婚
      t.string :has_children #是否有子女（性别）
      t.string :has_car #是否有车（品牌）
      t.string :other_about #其他（个人兴趣，爱好）
      t.text :notes
      t.integer :deleted,:limit=>2,:default=>0 #是否已经删除1已经删除0未删除
      t.integer :created_by
      t.integer :updated_by
      t.timestamps
    end
  end
end
