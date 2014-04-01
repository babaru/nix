class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
    attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :role_ids, :space_ids, :space_roles,:department_id
  # attr_accessible :title, :body
  has_many :user_permissions
  has_many :permissions,through: :user_permissions

  has_many :department_users
  has_many :departments, through: :department_users
  belongs_to :department

  def self.all_the_other_users(user_id)
    result = []
    User.all.each do |u|
      result << u if u.id != user_id
    end
    result
  end

  def is_sys_admin?
    (!self.blank? and self.email=='admin@nix.in')
  end

  def name_info
    if self.name.blank?
      self.email
    else
      self.name
    end
  end
end
