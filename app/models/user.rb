class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :role_ids, :space_ids, :space_roles,:department_id,:permission_ids
  # attr_accessible :title, :body
  has_many :user_permissions
  has_many :permissions,through: :user_permissions

  has_many :department_users
  has_many :departments, through: :department_users
  belongs_to :department
  validates :name, presence:{message:'用户名不能为空！'}
  validates :email, presence:{message:'邮箱不能为空！'}


  def self.all_the_other_users(user_id)
    result = []
    User.all.each do |u|
      result << u if u.id != user_id
    end
    result
  end

  def self.add_users
    attr = [['陈冬红','chendonghong@iforce-media.com'],
            ['李晶','lijing@iforce-media.com'],
            ['王珊珊','wangshanshan@iforce-media.com'],
            ['KIMI','kimi.liang@iforce-media.com'],
            ['王瑞','wangrui@iforce-media.com'],
            ['xuhuajun','xuhuajun@bester-media.com'],
            ['jimmy.huang','jimmy.huang@iforce-media.com'],
            ['anuhan','anuhan@iforce-media.com']]
    attr.each do |a|
      if User.where('email=?',a[1]).blank?
        User.create({:name=>a[0],:email=>a[1],:password=>'123456789'})
      end
    end
    puts "---------------end"
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
