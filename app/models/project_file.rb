class ProjectFile < ActiveRecord::Base
  attr_accessible :project_id, :file_category_id,:file_name,:save_name,:deleted,:created_by,:updated_by
end
