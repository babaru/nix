class AddInfoToGrassResources < ActiveRecord::Migration
  def change
    add_column :grass_resources,:read_count,:integer
    add_column :grass_resources,:trade,:string #行业
    add_column :grass_resources,:partnership,:string #合作关系
    add_column :grass_resources,:level,:integer #推荐级别
    add_column :grass_resources,:contact_name,:string #联系人
    add_column :grass_resources,:contact_way,:string #联系方式

  end
end
