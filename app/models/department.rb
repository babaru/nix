class Department < ActiveRecord::Base
  has_many :department_users
  has_many :users, through: :department_users
  has_many :department_permissions
  has_many :permissions, through: :department_permissions
  attr_accessible :name, :space_id, :permission_ids, :user_ids
end
