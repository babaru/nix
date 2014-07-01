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
    attr +=[['阿努罕','anuhan@iforce-media.com'],
            ['孙培毅','sunpeiyi@iforce-media.com'],
            ['邹松','zousong@iforce-media.com'],
            ['徐哲','xuzhe@iforce-media.com'],
            ['余力敏','yulihe@iforce-media.com'],
            ['徐艺纯','xuyichun@iforce-media.com'],
            ['宋丽娜','songlina@iforce-media.com'],
            ['吴雪娇','wuxuejiao@iforce-media.com'],
            ['刘锋',' liufeng@iforce-media.com'],
            ['郭骁超','guoxiaochao@iforce-media.com'],
            ['赵欣','zhaoxin@iforce-media.com'],
            ['刘璐','liulu@iforce-media.com'],
            ['董玮','dongwei@iforce-media.com'],
            ['史文彬','shiwenbin@iforce-media.com'],
            ['李巧叶','liqiaoye@iforce-media.com'],
            ['汪宇婷','wangyuting@iforce-media.com'],
            ['王杨','wangyang@iforce-media.com'],
            ['安晓伟','anxiaowei@iforce-media.com'],
            ['任宏斐','renhongfei@iforce-media.com'],
            ['秦玉苗','qinyumiao@iforce-media.com'],
            ['王爽','wangshuang@iforce-media.com'],
            ['张颜','zhangyan@iforce-media.com'],
            ['孙伟','sunwei@iforce-media.com'],
            ['王忠义','wangzhongyi@iforce-media.com'],
            ['杨霄霄','yangxiaoxiao@iforce-media.com'],
            ['房伟','fangwei@iforce-media.com'],
            ['苗健','miaojian@iforce-media.com'],
            ['于洋','yuyang@iforce-media.com'],
            ['陈琳','chenlin@iforce-media.com'],
            ['王卉','wanghui@iforce-media.com'],
            ['王景芸','wangjingyun@iforce-media.com'],
            ['朱红玉','zhuhongyu@iforce-media.com'],
            ['翟靖','zhaijing@iforce-media.com'],
            ['史家欢','shijiahuan@iforce-media.com'],
            ['刘海旭','liuhaixu@iforce-media.com'],
            ['唐颖','ying.tang@bester-media.com'],
            ['孙剑','sj1803@bester-media.com'],
            ['黄明','jimmy.huang@bester-media.com'],
            ['','jimmy.huang@iforce-media.com'],
            ['胥茜','xuxi@bester-media.com'],
            ['李霄雄','lixiaoxiong@bester-media.com'],
            ['尚笑梅','shangxiaomei@bester-media.com'],
            ['李建','lijian@bester-media.com'],
            ['王玥','wangyue@bester-media.com'],
            ['李伟','liwei@bester-media.com'],
            ['崔永莉','cuiyongli@bester-media.com'],
            ['介龙涛','jielongtao@bester-media.com'],
            ['倪恩杰','nienjie@bester-media.com'],
            ['夏晓锐','xiaxiaorui@bester-media.com'],
            ['杨智敏','yolanda.yang@bester-media.com'],
            ['商勇','shangyong@bester-media.com'],
            ['孙李丽子','sunlilizi@bester-media.com'],
            ['许华军','xuhuajun@bester-media.com'],
            ['佟蓉蓉','tongrr@bester-media.com'],
            ['周际','zhouji@bester-media.com']]
    attr += [['包纪青','jiqing_bao@iforce-media.com'],
             ['李晶','lijing@iforce-media.com'],
             ['丁铭伟','joe.ding@iforce-media.com'],
             ['韩露','hanlu@iforce-media.com'],
             ['施军军','shijunjun@iforce-media.com'],
             ['王莉莎','wanglisha@iforce-media.com'],
             ['吴文超','wuwenchao@iforce-media.com'],
             ['乔文婷','qiaowenting@iforce-media.com'],
             ['周云','zhouyun@iforce-media.com'],
             ['张律','zhanglv@iforce-media.com'],
             ['陈琦','chenqi@iforce-media.com'],
             ['王珊珊','wangshanshan@iforce-media.com'],
             ['王瑞','wangrui@iforce-media.com'],
             ['闪苏超','shansuchao@iforce-media.com'],
             ['何默','hemo@iforce-media.com'],
             ['王健','wangjian@iforce-media.com'],
             ['吴晔飞','wuyefei@iforce-media.com'],
             ['叶彬彬','yebinbin@iforce-media.com'],
             ['孙伟伟','sunweiwei@iforce-media.com'],
             ['章俊华','zhangjunhua@iforce-media.com'],
             ['黄瑾','huangjin@iforce-media.com'],
             ['宋梅','songmei@iforce-media.com'],
             ['申晟','shensheng@iforce-media.com'],
             ['甘圆','ganyuan@iforce-media.com'],
             ['陈周琼','chenzhouqiong@iforce-media.com'],
             ['崔新清','cuixinqing@iforce-media.com'],
             ['孙富萍','sunfuping@iforce-media.com'],
             ['刘丽','liuli@ifroce-media.com'],
             ['王静','wangjing@iforce-media.com'],
             ['乔明','tigerqiao@iforce-media.com'],
             ['邵瑾','shaojin@iforce-media.com'],
             ['谭亦珏','tanyijue@iforce-media.com'],
             ['陈冬红','chendonghong@iforce-media.com'],
             ['刘晶晶','liujingjing@iforce-media.com']]
    _models = ['BusinessCategory','Client','Order','Project','Supplier',
               'GrassResource','Moderator','WebSiteMediaReporter','FashionMediaInfo','TravelingPhotographyMediaInfo',
               'NetworkOpinionLeaderBlogger','SupplierEvaluation']
    attr.each do |a|
      if User.where('email=?',a[1]).blank? and !a[1].blank?
        user = User.create({:name=>a[0].to_s,:email=>a[1].to_s.strip,:password=>'123456789'})
        user.permissions = Permission.where('subject_class in (?) and action= ?',_models,'read')
        user.save
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
