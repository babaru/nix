class DepartmentPermission < ActiveRecord::Base
  belongs_to :department
  belongs_to :permission
  attr_accessible :department_id, :permission_id
end
