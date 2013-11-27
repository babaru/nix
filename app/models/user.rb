class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
    attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :role_ids, :space_ids, :space_roles
  # attr_accessible :title, :body

  def is_sys_admin?
    has_sys_role? :sys_admin
  end
  def has_sys_role?(role_sym)
    roles.any? { |r| r.name.underscore.to_sym == role_sym }
  end
end
