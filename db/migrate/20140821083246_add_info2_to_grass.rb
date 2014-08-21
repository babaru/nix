class AddInfo2ToGrass < ActiveRecord::Migration
  def change
    add_column :grass_resources,:out_price,:integer #对外报价
    add_column :grass_resources,:notes,:text #备注
  end
end
