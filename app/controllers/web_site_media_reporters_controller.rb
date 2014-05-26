class WebSiteMediaReportersController < ApplicationController
  before_filter :has_login
  add_breadcrumb(I18n.t('model.list', model: WebSiteMediaReporter.model_name.human), :web_site_media_reporters_path, only: :index)


  def index
    sql,sql_attr=' deleted=0 ',[]
    unless params[:region_id].to_i==0
      sql += " and region_id = ? "
      sql_attr << params[:region_id]
    end

    unless params[:province_id].to_i==0
      sql += " and province_id = ? "
      sql_attr << params[:province_id]
    end

    unless params[:city_id].to_i==0
      sql += " and city_id = ? "
      sql_attr << params[:city_id]
    end

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

    @reporters_grid = initialize_grid(WebSiteMediaReporter.where([sql]+sql_attr))
    @provinces ,@cities = [],[]
    @regions=Region.all().map{|o| [o.name,o.id]} || []
    @provinces = Province.where(:region_id => params[:region_id].to_i).map{|o| [o.name,o.id]} unless params[:region_id].blank?
    @cities = City.where(:province_id => params[:province_id].to_i).map{|o| [o.name,o.id]} unless params[:province_id].blank?
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @reporters_grid }
    end
  end

  def new
    @reporter = WebSiteMediaReporter.new
    @reporter.created_by = current_user.id
    @regions=Region.all() || []
    @provinces = Province.where(:region_id => @regions.first().id) unless @regions.blank?
    @cities = City.where(:province_id => @provinces.first().id) unless @provinces.blank?

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
        @regions=Region.all() || []
        @provinces = Province.where(:region_id => @regions.first().id) unless @regions.blank?
        @cities = City.where(:province_id => @provinces.first().id) unless @provinces.blank?
        format.html { render action: "new" }
        format.json { render json: @reporter.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @reporter = WebSiteMediaReporter.find(params[:id])
    @regions=Region.all() || []
    @provinces = Province.where(:region_id => @reporter.region_id) unless @regions.blank?
    @cities = City.where(:province_id => @reporter.province_id) unless @provinces.blank?
  end

  def update
    @reporter = WebSiteMediaReporter.find(params[:id])
    @reporter.updated_by = current_user.id
    respond_to do |format|
      if @reporter.update_attributes(params[:web_site_media_reporter])
        format.html { redirect_to web_site_media_reporters_path, notice: "成功修改#{WebSiteMediaReporter.model_name.human}" }
        format.json { head :no_content }
      else
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
    txt = ""
    region = Region.find_by_id(params[:id].to_i)
    _provinces = []
    _provinces = region.provinces unless region.blank?
    _provinces.each do |s|
      txt  = txt + "<option value='#{s.id}'>#{s.name}</option>"
    end
    render :text => txt
  end

  def ajax_get_cities
    txt = ""
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
    unless params[:region_id].to_i==0
      sql += " and region_id = ? "
      sql_attr << params[:region_id]
    end

    unless params[:province_id].to_i==0
      sql += " and province_id = ? "
      sql_attr << params[:province_id]
    end

    unless params[:city_id].to_i==0
      sql += " and city_id = ? "
      sql_attr << params[:city_id]
    end

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
          begin
            new_file_name = upload_file(params[:excel_file], "/public/files/temp/")
            workbook = Spreadsheet.open("#{Rails.root}/public/files/temp/"+new_file_name)

            _sheet = workbook.worksheet(0)
            WebSiteMediaReporter.create_by_excel(_sheet,current_user)
            FileUtils.rm Dir["#{Rails.root}/public/files/temp/*.xls"]
            #if error_numbers.count>0
            #  respond_to do |format|
            #    format.html { redirect_to web_site_media_reporters_path, alert: "上传失败，失败编号为#{error_numbers.join(",")}。请检查城市是否填写正确！！！" }
            #    format.json { render json: {}, status: :created, location: {} }
            #  end
            #else
            #  respond_to do |format|
            #    format.html { redirect_to web_site_media_reporters_path, notice: "上传完成！！！" }
            #    format.json { render json: {}, status: :created, location: {} }
            #  end
            #end

            respond_to do |format|
              format.html { redirect_to web_site_media_reporters_path, notice: "上传完成！！！" }
              format.json { render json: {}, status: :created, location: {} }
            end

          rescue Exception => e
            ActiveRecord::Rollback
            render :text => "<script>alert('#{e.to_s}');history.go(-1);</script>"
            return
          end
        else
          render :text => "<script>alert('格式错误!');history.go(-1);</script>"
        end
      end
    end
  end
end






































