attr = ['华北地区','东北地区','华东地区','西南地区','中南地区','西北地区','其他地区']
attr.each do |r|
  Region.create({:name=>r})
end

attr = [['北京市','1','直辖市'],
        ['天津市','1','直辖市'],
        ['河北省','1','省份'],
        ['山西省','1','省份'],
        ['内蒙古自治区','1','自治区'],
        ['辽宁省','2','省份'],
        ['吉林省','2','省份'],
        ['黑龙江省','2','省份'],
        ['上海市','3','直辖市'],
        ['江苏省','3','省份'],
        ['浙江省','3','省份'],
        ['安徽省','3','省份'],
        ['福建省','3','省份'],
        ['江西省','3','省份'],
        ['山东省','3','省份'],
        ['河南省','5','省份'],
        ['湖北省','5','省份'],
        ['湖南省','5','省份'],
        ['广东省','5','省份'],
        ['海南省','5','省份'],
        ['广西壮族自治区','5','自治区'],
        ['甘肃省','6','省份'],
        ['陕西省','6','省份'],
        ['新疆维吾尔自治区','6','自治区'],
        ['青海省','6','省份'],
        ['宁夏回族自治区','6','自治区'],
        ['重庆市','4','直辖市'],
        ['四川省','4','省份'],
        ['贵州省','4','省份'],
        ['云南省','4','省份'],
        ['西藏自治区','4','自治区'],
        ['台湾省','7','省份'],
        ['澳门特别行政区','7','特别行政区'],
        ['香港特别行政区','7','特别行政区']]
attr.each do |p|
  Province.create!({:name=>p[0],:remark=>p[2],:region_id=>p[1].to_i})
end

attr = [['北京市','1','1'],
        ['天津市','2','2'],
        ['上海市','9','3'],
        ['重庆市','27','4'],
        ['邯郸市','3','5'],
        ['石家庄市','3','6'],
        ['保定市','3','7'],
        ['张家口市','3','8'],
        ['承德市','3','9'],
        ['唐山市','3','10'],
        ['廊坊市','3','11'],
        ['沧州市','3','12'],
        ['衡水市','3','13'],
        ['邢台市','3','14'],
        ['秦皇岛市','3','15'],
        ['朔州市','4','16'],
        ['忻州市','4','17'],
        ['太原市','4','18'],
        ['大同市','4','19'],
        ['阳泉市','4','20'],
        ['晋中市','4','21'],
        ['长治市','4','22'],
        ['晋城市','4','23'],
        ['临汾市','4','24'],
        ['吕梁市','4','25'],
        ['运城市','4','26'],
        ['沈阳市','6','27'],
        ['铁岭市','6','28'],
        ['大连市','6','29'],
        ['鞍山市','6','30'],
        ['抚顺市','6','31'],
        ['本溪市','6','32'],
        ['丹东市','6','33'],
        ['锦州市','6','34'],
        ['营口市','6','35'],
        ['阜新市','6','36'],
        ['辽阳市','6','37'],
        ['朝阳市','6','38'],
        ['盘锦市','6','39'],
        ['葫芦岛市','6','40'],
        ['长春市','7','41'],
        ['吉林市','7','42'],
        ['延边朝鲜族自治州','7','43'],
        ['四平市','7','44'],
        ['通化市','7','45'],
        ['白城市','7','46'],
        ['辽源市','7','47'],
        ['松原市','7','48'],
        ['白山市','7','49'],
        ['哈尔滨市','8','50'],
        ['齐齐哈尔市','8','51'],
        ['鸡西市','8','52'],
        ['牡丹江市','8','53'],
        ['七台河市','8','54'],
        ['佳木斯市','8','55'],
        ['鹤岗市','8','56'],
        ['双鸭山市','8','57'],
        ['绥化市','8','58'],
        ['黑河市','8','59'],
        ['大兴安岭地区','8','60'],
        ['伊春市','8','61'],
        ['大庆市','8','62'],
        ['南京市','10','63'],
        ['无锡市','10','64'],
        ['镇江市','10','65'],
        ['苏州市','10','66'],
        ['南通市','10','67'],
        ['扬州市','10','68'],
        ['盐城市','10','69'],
        ['徐州市','10','70'],
        ['淮安市','10','71'],
        ['连云港市','10','72'],
        ['常州市','10','73'],
        ['泰州市','10','74'],
        ['宿迁市','10','75'],
        ['舟山市','11','76'],
        ['衢州市','11','77'],
        ['杭州市','11','78'],
        ['湖州市','11','79'],
        ['嘉兴市','11','80'],
        ['宁波市','11','81'],
        ['绍兴市','11','82'],
        ['温州市','11','83'],
        ['丽水市','11','84'],
        ['金华市','11','85'],
        ['台州市','11','86'],
        ['合肥市','12','87'],
        ['芜湖市','12','88'],
        ['蚌埠市','12','89'],
        ['淮南市','12','90'],
        ['马鞍山市','12','91'],
        ['淮北市','12','92'],
        ['铜陵市','12','93'],
        ['安庆市','12','94'],
        ['黄山市','12','95'],
        ['滁州市','12','96'],
        ['阜阳市','12','97'],
        ['宿州市','12','98'],
        ['巢湖市','12','99'],
        ['六安市','12','100'],
        ['亳州市','12','101'],
        ['池州市','12','102'],
        ['宣城市','12','103'],
        ['福州市','13','104'],
        ['厦门市','13','105'],
        ['宁德市','13','106'],
        ['莆田市','13','107'],
        ['泉州市','13','108'],
        ['漳州市','13','109'],
        ['龙岩市','13','110'],
        ['三明市','13','111'],
        ['南平市','13','112'],
        ['鹰潭市','14','113'],
        ['新余市','14','114'],
        ['南昌市','14','115'],
        ['九江市','14','116'],
        ['上饶市','14','117'],
        ['抚州市','14','118'],
        ['宜春市','14','119'],
        ['吉安市','14','120'],
        ['赣州市','14','121'],
        ['景德镇市','14','122'],
        ['萍乡市','14','123'],
        ['菏泽市','15','124'],
        ['济南市','15','125'],
        ['青岛市','15','126'],
        ['淄博市','15','127'],
        ['德州市','15','128'],
        ['烟台市','15','129'],
        ['潍坊市','15','130'],
        ['济宁市','15','131'],
        ['泰安市','15','132'],
        ['临沂市','15','133'],
        ['滨州市','15','134'],
        ['东营市','15','135'],
        ['威海市','15','136'],
        ['枣庄市','15','137'],
        ['日照市','15','138'],
        ['莱芜市','15','139'],
        ['聊城市','15','140'],
        ['商丘市','16','141'],
        ['郑州市','16','142'],
        ['安阳市','16','143'],
        ['新乡市','16','144'],
        ['许昌市','16','145'],
        ['平顶山市','16','146'],
        ['信阳市','16','147'],
        ['南阳市','16','148'],
        ['开封市','16','149'],
        ['洛阳市','16','150'],
        ['济源市','16','151'],
        ['焦作市','16','152'],
        ['鹤壁市','16','153'],
        ['濮阳市','16','154'],
        ['周口市','16','155'],
        ['漯河市','16','156'],
        ['驻马店市','16','157'],
        ['三门峡市','16','158'],
        ['武汉市','17','159'],
        ['襄樊市','17','160'],
        ['鄂州市','17','161'],
        ['孝感市','17','162'],
        ['黄冈市','17','163'],
        ['黄石市','17','164'],
        ['咸宁市','17','165'],
        ['荆州市','17','166'],
        ['宜昌市','17','167'],
        ['恩施土家族苗族自治州','17','168'],
        ['神农架林区','17','169'],
        ['十堰市','17','170'],
        ['随州市','17','171'],
        ['荆门市','17','172'],
        ['仙桃市','17','173'],
        ['天门市','17','174'],
        ['潜江市','17','175'],
        ['岳阳市','18','176'],
        ['长沙市','18','177'],
        ['湘潭市','18','178'],
        ['株洲市','18','179'],
        ['衡阳市','18','180'],
        ['郴州市','18','181'],
        ['常德市','18','182'],
        ['益阳市','18','183'],
        ['娄底市','18','184'],
        ['邵阳市','18','185'],
        ['湘西土家族苗族自治州','18','186'],
        ['张家界市','18','187'],
        ['怀化市','18','188'],
        ['永州市','18','189'],
        ['广州市','19','190'],
        ['汕尾市','19','191'],
        ['阳江市','19','192'],
        ['揭阳市','19','193'],
        ['茂名市','19','194'],
        ['惠州市','19','195'],
        ['江门市','19','196'],
        ['韶关市','19','197'],
        ['梅州市','19','198'],
        ['汕头市','19','199'],
        ['深圳市','19','200'],
        ['珠海市','19','201'],
        ['佛山市','19','202'],
        ['肇庆市','19','203'],
        ['湛江市','19','204'],
        ['中山市','19','205'],
        ['河源市','19','206'],
        ['清远市','19','207'],
        ['云浮市','19','208'],
        ['潮州市','19','209'],
        ['东莞市','19','210'],
        ['兰州市','22','211'],
        ['金昌市','22','212'],
        ['白银市','22','213'],
        ['天水市','22','214'],
        ['嘉峪关市','22','215'],
        ['武威市','22','216'],
        ['张掖市','22','217'],
        ['平凉市','22','218'],
        ['酒泉市','22','219'],
        ['庆阳市','22','220'],
        ['定西市','22','221'],
        ['陇南市','22','222'],
        ['临夏回族自治州','22','223'],
        ['甘南藏族自治州','22','224'],
        ['成都市','28','225'],
        ['攀枝花市','28','226'],
        ['自贡市','28','227'],
        ['绵阳市','28','228'],
        ['南充市','28','229'],
        ['达州市','28','230'],
        ['遂宁市','28','231'],
        ['广安市','28','232'],
        ['巴中市','28','233'],
        ['泸州市','28','234'],
        ['宜宾市','28','235'],
        ['资阳市','28','236'],
        ['内江市','28','237'],
        ['乐山市','28','238'],
        ['眉山市','28','239'],
        ['凉山彝族自治州','28','240'],
        ['雅安市','28','241'],
        ['甘孜藏族自治州','28','242'],
        ['阿坝藏族羌族自治州','28','243'],
        ['德阳市','28','244'],
        ['广元市','28','245'],
        ['贵阳市','29','246'],
        ['遵义市','29','247'],
        ['安顺市','29','248'],
        ['黔南布依族苗族自治州','29','249'],
        ['黔东南苗族侗族自治州','29','250'],
        ['铜仁地区','29','251'],
        ['毕节地区','29','252'],
        ['六盘水市','29','253'],
        ['黔西南布依族苗族自治州','29','254'],
        ['海口市','20','255'],
        ['三亚市','20','256'],
        ['五指山市','20','257'],
        ['琼海市','20','258'],
        ['儋州市','20','259'],
        ['文昌市','20','260'],
        ['万宁市','20','261'],
        ['东方市','20','262'],
        ['澄迈县','20','263'],
        ['定安县','20','264'],
        ['屯昌县','20','265'],
        ['临高县','20','266'],
        ['白沙黎族自治县','20','267'],
        ['昌江黎族自治县','20','268'],
        ['乐东黎族自治县','20','269'],
        ['陵水黎族自治县','20','270'],
        ['保亭黎族苗族自治县','20','271'],
        ['琼中黎族苗族自治县','20','272'],
        ['西双版纳傣族自治州','30','273'],
        ['德宏傣族景颇族自治州','30','274'],
        ['昭通市','30','275'],
        ['昆明市','30','276'],
        ['大理白族自治州','30','277'],
        ['红河哈尼族彝族自治州','30','278'],
        ['曲靖市','30','279'],
        ['保山市','30','280'],
        ['文山壮族苗族自治州','30','281'],
        ['玉溪市','30','282'],
        ['楚雄彝族自治州','30','283'],
        ['普洱市','30','284'],
        ['临沧市','30','285'],
        ['怒江傈傈族自治州','30','286'],
        ['迪庆藏族自治州','30','287'],
        ['丽江市','30','288'],
        ['海北藏族自治州','25','289'],
        ['西宁市','25','290'],
        ['海东地区','25','291'],
        ['黄南藏族自治州','25','292'],
        ['海南藏族自治州','25','293'],
        ['果洛藏族自治州','25','294'],
        ['玉树藏族自治州','25','295'],
        ['海西蒙古族藏族自治州','25','296'],
        ['西安市','23','297'],
        ['咸阳市','23','298'],
        ['延安市','23','299'],
        ['榆林市','23','300'],
        ['渭南市','23','301'],
        ['商洛市','23','302'],
        ['安康市','23','303'],
        ['汉中市','23','304'],
        ['宝鸡市','23','305'],
        ['铜川市','23','306'],
        ['防城港市','21','307'],
        ['南宁市','21','308'],
        ['崇左市','21','309'],
        ['来宾市','21','310'],
        ['柳州市','21','311'],
        ['桂林市','21','312'],
        ['梧州市','21','313'],
        ['贺州市','21','314'],
        ['贵港市','21','315'],
        ['玉林市','21','316'],
        ['百色市','21','317'],
        ['钦州市','21','318'],
        ['河池市','21','319'],
        ['北海市','21','320'],
        ['拉萨市','31','321'],
        ['日喀则地区','31','322'],
        ['山南地区','31','323'],
        ['林芝地区','31','324'],
        ['昌都地区','31','325'],
        ['那曲地区','31','326'],
        ['阿里地区','31','327'],
        ['银川市','26','328'],
        ['石嘴山市','26','329'],
        ['吴忠市','26','330'],
        ['固原市','26','331'],
        ['中卫市','26','332'],
        ['塔城地区','24','333'],
        ['哈密地区','24','334'],
        ['和田地区','24','335'],
        ['阿勒泰地区','24','336'],
        ['克孜勒苏柯尔克孜自治州','24','337'],
        ['博尔塔拉蒙古自治州','24','338'],
        ['克拉玛依市','24','339'],
        ['乌鲁木齐市','24','340'],
        ['石河子市','24','341'],
        ['昌吉回族自治州','24','342'],
        ['五家渠市','24','343'],
        ['吐鲁番地区','24','344'],
        ['巴音郭楞蒙古自治州','24','345'],
        ['阿克苏地区','24','346'],
        ['阿拉尔市','24','347'],
        ['喀什地区','24','348'],
        ['图木舒克市','24','349'],
        ['伊犁哈萨克自治州','24','350'],
        ['呼伦贝尔市','5','351'],
        ['呼和浩特市','5','352'],
        ['包头市','5','353'],
        ['乌海市','5','354'],
        ['乌兰察布市','5','355'],
        ['通辽市','5','356'],
        ['赤峰市','5','357'],
        ['鄂尔多斯市','5','358'],
        ['巴彦淖尔市','5','359'],
        ['锡林郭勒盟','5','360'],
        ['兴安盟','5','361'],
        ['阿拉善盟','5','362'],
        ['台北市','32','363'],
        ['高雄市','32','364'],
        ['基隆市','32','365'],
        ['台中市','32','366'],
        ['台南市','32','367'],
        ['新竹市','32','368'],
        ['嘉义市','32','369'],
        ['澳门特别行政区','33','370'],
        ['香港特别行政区','34','371']]

attr.each do |c|
  City.create!({:name=>c[0],:province_id=>c[1].to_i})
end
