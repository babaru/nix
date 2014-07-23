class AddQqToFashionMediaInfos < ActiveRecord::Migration
  def change
    add_column :fashion_media_infos,:qq,:string
    add_column :traveling_photography_media_infos,:qq,:string
    add_column :network_opinion_leader_bloggers,:qq,:string
    add_column :moderators,:qq,:string
  end
end
