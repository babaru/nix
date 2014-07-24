class TravelingPhotographyMediaInfosController < ApplicationController

  before_filter :has_login
  add_breadcrumb(I18n.t('model.list', model: TravelingPhotographyMediaInfo.model_name.human), :traveling_photography_media_infos_path, except: :index)
  def index
    sql,sql_attr=' deleted=0',[]

    unless params[:web_site].blank?
      sql += " and web_site like ? "
      sql_attr << "%"+params[:web_site]+"%"
    end

    unless params[:content_name].blank?
      sql += " and content_name like ? "
      sql_attr << "%"+params[:content_name]+"%"
    end

    unless params[:position].blank?
      sql += " and position like ? "
      sql_attr << "%"+params[:position]+"%"
    end

    unless params[:mobile].blank?
      sql += " and mobile like ? "
      sql_attr << "%"+params[:mobile]+"%"
    end

    unless params[:email].blank?
      sql += " and email like ? "
      sql_attr << "%"+params[:email]+"%"
    end

    unless params[:coverage].blank?
      sql += " and coverage >= ? "
      sql_attr << params[:coverage].to_f
    end

    unless params[:coverage1].blank?
      sql += " and coverage <= ? "
      sql_attr << params[:coverage1].to_f
    end

    @medias_grid = initialize_grid(TravelingPhotographyMediaInfo.where([sql]+sql_attr))
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @medias_grid }
    end
  end

  def new
    @media = TravelingPhotographyMediaInfo.new()
    @media.created_by = current_user.id
    @cities = City.all(:order=>'province_id asc')

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @media }
    end
  end

  def create
    @media = TravelingPhotographyMediaInfo.new(params[:traveling_photography_media_info])

    @media.updated_by = current_user.id
    @media.created_by = current_user.id

    respond_to do |format|
      if @media.other_valid? and @media.save
        format.html { redirect_to traveling_photography_media_infos_path, notice: "成功创建#{TravelingPhotographyMediaInfo.model_name.human}" }
        format.json { render json: @media, status: :created, location: @media }
      else
        format.html { render action: "new" }
        format.json { render json: @media.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @media = TravelingPhotographyMediaInfo.find(params[:id])
  end

  def update
    @media = TravelingPhotographyMediaInfo.find(params[:id])
    @media.attributes=params[:traveling_photography_media_info]
    @media.updated_by = current_user.id
    respond_to do |format|
      if @media.other_valid? and @media.save
        format.html { redirect_to traveling_photography_media_infos_path, notice: "成功修改#{TravelingPhotographyMediaInfo.model_name.human}" }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @media.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @media = TravelingPhotographyMediaInfo.find(params[:id])
    @media.deleted=1

    if @media.save
      respond_to do |format|
        format.html { redirect_to traveling_photography_media_infos_path, notice: "成功删除#{TravelingPhotographyMediaInfo.model_name.human}" }
        format.json { head :no_content }
      end
    end
  end

  def download_traveling_photography_media_info
    sql,sql_attr=' deleted=0',[]

    unless params[:web_site].blank?
      sql += " and web_site like ? "
      sql_attr << "%"+params[:web_site]+"%"
    end

    unless params[:content_name].blank?
      sql += " and content_name like ? "
      sql_attr << "%"+params[:content_name]+"%"
    end

    unless params[:position].blank?
      sql += " and position like ? "
      sql_attr << "%"+params[:position]+"%"
    end

    unless params[:mobile].blank?
      sql += " and mobile like ? "
      sql_attr << "%"+params[:mobile]+"%"
    end

    unless params[:email].blank?
      sql += " and email like ? "
      sql_attr << "%"+params[:email]+"%"
    end

    unless params[:coverage].blank?
      sql += " and coverage >= ? "
      sql_attr << params[:coverage].to_f
    end

    unless params[:coverage1].blank?
      sql += " and coverage <= ? "
      sql_attr << params[:coverage1].to_f
    end


    data = TravelingPhotographyMediaInfo.where([sql]+sql_attr)
    new_file = TravelingPhotographyMediaInfo.create_new_template(data)
    send_file new_file, :type => "application/octet-stream", :disposition => "attachment"
  end

  def upload_traveling_photography_media_info
    if request.post?
      if params[:excel_file].blank?
        render :text => "<script>alert('请选择上传的文件!');history.go(-1);</script>"
      else
        if %w(xls).include?(params[:excel_file].original_filename.to_s.split('.')[-1])
          begin
            new_file_name = upload_file(params[:excel_file], "/public/files/temp/")
            workbook = Spreadsheet.open("#{Rails.root}/public/files/temp/"+new_file_name)

            _sheet = workbook.worksheet(0)
            _error_info = TravelingPhotographyMediaInfo.create_by_excel(_sheet,current_user)
            FileUtils.rm Dir["#{Rails.root}/public/files/temp/*.xls"]
            respond_to do |format|
              if _error_info == ''
                format.html { redirect_to traveling_photography_media_infos_path(), notice: '上传完成！！！' }
                format.json { render json: {}, status: :created, location: {} }
              else
                format.html { redirect_to traveling_photography_media_infos_path(), alert: _error_info }
                format.json { render json: {}, status: :created, location: {} }
              end
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
