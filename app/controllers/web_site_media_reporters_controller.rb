class WebSiteMediaReportersController < ApplicationController
  before_filter :has_login
  add_breadcrumb(I18n.t('model.list', model: WebSiteMediaReporter.model_name.human), :web_site_media_reporters_path, except: :index)


  def index
    sql,sql_attr=' deleted=0 ',[]


    unless params[:format_id].to_i==0
      sql += " and format_id = ?"
      sql_attr << params[:format_id].to_i
    end

    unless params[:media_name].blank?
      sql += " and media_name like ?"
      sql_attr << "%"+params[:media_name].to_s+"%"
    end

    unless params[:level].blank?
      sql += " and level = ?"
      sql_attr << params[:level]
    end

    unless params[:name].blank?
      sql += " and name like ?"
      sql_attr << "%"+params[:name].to_s+"%"
    end

    unless params[:sex].blank?
      sql += " and sex = ?"
      sql_attr << params[:sex].to_i
    end

    unless params[:department_name].blank?
      sql += " and department_name like ?"
      sql_attr << "%"+params[:department_name].to_s+"%"
    end

    unless params[:birthday_start].blank?
      sql += " and birthday >= ?"
      sql_attr << params[:birthday_start]
    end

    unless params[:birthday_end].blank?
      sql += " and birthday <= ?"
      sql_attr << params[:birthday_end]
    end

    if params[:is_substation]=='1'
      sql += " and is_substation = 1"
    end

    @cities = City::PLACES
    unless params[:city_select_ids].blank?
      city_ids = City.get_city_ids(params[:city_select_ids].split(','))

      sql += " and city_id in (?)"
      sql_attr << city_ids
      _city = @cities.select{|x| params[:city_select_ids].split(',').include?(x[1].to_s)}

      @city_select_name = _city.map{|x| x[0]}.join('/') unless _city.blank?
    end

    @formats = WebSiteMediaReporter::FORMATS
    unless params[:format_select_ids].blank?
      sql += " and format_id in (?)"
      sql_attr << params[:format_select_ids].split(',')
      _format = @formats.select{|x| params[:format_select_ids].split(',').include?(x[1].to_s)}
      @format_select_name = _format.map{|x| x[0]}.join('/') unless _format.blank?
    end

    @levels = WebSiteMediaReporter::LEVELS
    unless params[:level_select_ids].blank?
      sql += " and level in (?)"
      sql_attr << params[:level_select_ids].split(',')
      _level = @levels.select{|x| params[:level_select_ids].split(',').include?(x[1].to_s)}
      @level_select_name = _level.map{|x| x[0]}.join('/') unless _level.blank?
    end



    @reporters_grid = initialize_grid(WebSiteMediaReporter.where([sql]+sql_attr),:per_page=>50)
    @provinces  = []
    @regions=Region.all().map{|o| [o.name,o.id]} || []
    @provinces = Province.where(:region_id => params[:region_id].to_i).map{|o| [o.name,o.id]} unless params[:region_id].blank?

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @reporters_grid }
    end
  end

  def new
    @reporter = WebSiteMediaReporter.new
    @reporter.created_by = current_user.id
    @regions,@provinces,@cities = [],[],[]
    @regions1=Region.all() || []
    @regions = @regions1.map{|x| [x.name,x.id]} unless @regions1.blank?
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @reporter }
    end
  end

  def create
    @reporter = WebSiteMediaReporter.new(params[:web_site_media_reporter])

    #@project.assigned_users << current_user
    @reporter.updated_by = current_user.id
    @reporter.created_by = current_user.id

    respond_to do |format|
      if @reporter.other_valid? and @reporter.save
        format.html { redirect_to web_site_media_reporters_path, notice: "成功创建#{WebSiteMediaReporter.model_name.human}" }
        format.json { render json: @reporter, status: :created, location: @reporter }
      else
        @regions,@provinces,@cities = [],[],[]
        @regions1=Region.all() || []
        @regions = @regions1.map{|x| [x.name,x.id]} unless @regions1.blank?
        @provinces1 = Province.where(:region_id => @reporter.region_id) unless @regions1.blank?
        @provinces = @provinces1.map{|x| [x.name,x.id]} unless @provinces1.blank?
        @cities1 = City.where(:province_id => @reporter.province_id) unless @provinces1.blank?
        @cities = @cities1.map{|x| [x.name,x.id]} unless @cities1.blank?
        format.html { render action: "new" }
        format.json { render json: @reporter.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @reporter = WebSiteMediaReporter.find(params[:id])
    @regions,@provinces,@cities = [],[],[]
    @regions1=Region.all() || []
    @regions = @regions1.map{|x| [x.name,x.id]} unless @regions1.blank?
    @provinces1 = Province.where(:region_id => @reporter.region_id) unless @regions1.blank?
    @provinces = @provinces1.map{|x| [x.name,x.id]} unless @provinces1.blank?
    @cities1 = City.where(:province_id => @reporter.province_id) unless @provinces1.blank?
    @cities = @cities1.map{|x| [x.name,x.id]} unless @cities1.blank?
  end

  def update
    @reporter = WebSiteMediaReporter.find(params[:id])
    @reporter.updated_by = current_user.id
    @reporter.attributes = params[:web_site_media_reporter]
    respond_to do |format|
      if @reporter.other_valid? and @reporter.save
        format.html { redirect_to web_site_media_reporters_path, notice: "成功修改#{WebSiteMediaReporter.model_name.human}" }
        format.json { head :no_content }
      else
        @regions,@provinces,@cities = [],[],[]
        @regions1=Region.all() || []
        @regions = @regions1.map{|x| [x.name,x.id]} unless @regions1.blank?
        @provinces1 = Province.where(:region_id => @reporter.region_id) unless @regions1.blank?
        @provinces = @provinces1.map{|x| [x.name,x.id]} unless @provinces1.blank?
        @cities1 = City.where(:province_id => @reporter.province_id) unless @provinces1.blank?
        @cities = @cities1.map{|x| [x.name,x.id]} unless @cities1.blank?
        format.html { render action: "edit" }
        format.json { render json: @reporter.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @reporter = WebSiteMediaReporter.find(params[:id])
    @reporter.deleted=1

    if @reporter.save
      respond_to do |format|
        format.html { redirect_to web_site_media_reporters_path, notice: "成功删除#{WebSiteMediaReporter.model_name.human}" }
        format.json { head :no_content }
      end
    end
  end



  def ajax_get_provinces
    txt = "<option value=''></option>"
    region = Region.find_by_id(params[:id].to_i)

    _provinces = []
    _provinces = region.provinces unless region.blank?
    _provinces.each do |s|
      txt  = txt + "<option value='#{s.id}'>#{s.name}</option>"
    end
    render :text => txt
  end

  def ajax_get_cities
    txt = "<option value=''></option>"
    province = Province.find_by_id(params[:id].to_i)
    _cities = []
    _cities = province.cities unless province.blank?
    _cities.each do |s|
      txt  = txt + "<option value='#{s.id}'>#{s.name}</option>"
    end
    render :text => txt
  end

  def download_reporter_info
    sql,sql_attr=' deleted=0 ',[]


    unless params[:format_id].to_i==0
      sql += " and format_id = ?"
      sql_attr << params[:format_id].to_i
    end

    unless params[:media_name].blank?
      sql += " and media_name like ?"
      sql_attr << "%"+params[:media_name].to_s+"%"
    end

    unless params[:level].blank?
      sql += " and level = ?"
      sql_attr << params[:level]
    end

    unless params[:name].blank?
      sql += " and name like ?"
      sql_attr << "%"+params[:name].to_s+"%"
    end

    unless params[:sex].blank?
      sql += " and sex = ?"
      sql_attr << params[:sex].to_i
    end

    unless params[:department_name].blank?
      sql += " and department_name like ?"
      sql_attr << "%"+params[:department_name].to_s+"%"
    end

    unless params[:birthday_start].blank?
      sql += " and birthday >= ?"
      sql_attr << params[:birthday_start]
    end

    unless params[:birthday_end].blank?
      sql += " and birthday <= ?"
      sql_attr << params[:birthday_end]
    end

    if params[:is_substation]=='1'
      sql += " and is_substation = 1"
    end

    @cities = City::PLACES
    unless params[:city_select_ids].blank?
      city_ids = City.get_city_ids(params[:city_select_ids].split(','))

      sql += " and city_id in (?)"
      sql_attr << city_ids
      _city = @cities.select{|x| params[:city_select_ids].split(',').include?(x[1].to_s)}

      @city_select_name = _city.map{|x| x[0]}.join('/') unless _city.blank?
    end

    @formats = WebSiteMediaReporter::FORMATS
    unless params[:format_select_ids].blank?
      sql += " and format_id in (?)"
      sql_attr << params[:format_select_ids].split(',')
      _format = @formats.select{|x| params[:format_select_ids].split(',').include?(x[1].to_s)}
      @format_select_name = _format.map{|x| x[0]}.join('/') unless _format.blank?
    end

    @levels = WebSiteMediaReporter::LEVELS
    unless params[:level_select_ids].blank?
      sql += " and level in (?)"
      sql_attr << params[:level_select_ids].split(',')
      _level = @levels.select{|x| params[:level_select_ids].split(',').include?(x[1].to_s)}
      @level_select_name = _level.map{|x| x[0]}.join('/') unless _level.blank?
    end

    data = WebSiteMediaReporter.where([sql]+sql_attr)
    new_file = WebSiteMediaReporter.create_new_template(data)
    send_file new_file, :type => "application/octet-stream", :disposition => "attachment"
  end

  def upload_reporter_info
    if request.post?
      if params[:excel_file].blank?
        render :text => "<script>alert('请选择上传的文件!');history.go(-1);</script>"
      else
        if %w(xls).include?(params[:excel_file].original_filename.to_s.split('.')[-1])
          #begin
            new_file_name = upload_file(params[:excel_file], "/public/files/temp/")
            workbook = Spreadsheet.open("#{Rails.root}/public/files/temp/"+new_file_name)

            _sheet = workbook.worksheet(0)
            _error_info = WebSiteMediaReporter.create_by_excel(_sheet,current_user)
            FileUtils.rm Dir["#{Rails.root}/public/files/temp/*.xls"]
            respond_to do |format|
              if _error_info == ''
                format.html { redirect_to web_site_media_reporters_path, notice: "上传完成！！！"}
                format.json { render json: {}, status: :created, location: {} }
              else
                format.html { redirect_to web_site_media_reporters_path(), alert: _error_info }
                format.json { render json: {}, status: :created, location: {} }
              end

            end
          #rescue Exception => e
          #  ActiveRecord::Rollback
          #  render :text => "<script>alert('#{e.to_s}');history.go(-1);</script>"
          #  return
          #end
        else
          render :text => "<script>alert('格式错误!');history.go(-1);</script>"
        end
      end
    end
  end
end






































