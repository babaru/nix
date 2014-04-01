class UserPermission < ActiveRecord::Base
  belongs_to :user
  belongs_to :permission
  attr_accessible :user_id, :permission_id
end
