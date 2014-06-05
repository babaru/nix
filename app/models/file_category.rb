class FileCategory < ActiveRecord::Base
  # attr_accessible :title, :body

  def children
    FileCategory.where('parent_id=?',self.id)
  end
end
