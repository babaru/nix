class FashionMediaInfosController < ApplicationController

  before_filter :has_login
  add_breadcrumb(I18n.t('model.list', model: FashionMediaInfo.model_name.human), :fashion_media_infos_path, except: :index)
  def index


    @medias_grid = initialize_grid(FashionMediaInfo.where(:deleted => 0))
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @medias_grid }
    end
  end

  def new
    @media = FashionMediaInfo.new()
    @media.created_by = current_user.id
    @cities = City.all(:order=>'province_id asc')

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @media }
    end
  end

  def create
    @media = FashionMediaInfo.new(params[:fashion_media_info])

    #@project.assigned_users << current_user
    @media.updated_by = current_user.id
    @media.created_by = current_user.id

    respond_to do |format|
      if @media.other_valid? and @media.save
        format.html { redirect_to fashion_media_infos_path, notice: "成功创建#{FashionMediaInfo.model_name.human}" }
        format.json { render json: @media, status: :created, location: @media }
      else
        @cities = City.all(:order=>'province_id asc')
        format.html { render action: "new" }
        format.json { render json: @media.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @media = FashionMediaInfo.find(params[:id])
    @cities = City.all(:order=>'province_id asc')
  end

  def update
    @media = FashionMediaInfo.find(params[:id])
    @media.updated_by = current_user.id
    respond_to do |format|
      if @media.update_attributes(params[:fashion_media_info])
        format.html { redirect_to fashion_media_infos_path, notice: "成功修改#{FashionMediaInfo.model_name.human}" }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @media.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @media = FashionMediaInfo.find(params[:id])
    @media.deleted=1

    if @media.save
      respond_to do |format|
        format.html { redirect_to fashion_media_infos_path, notice: "成功删除#{FashionMediaInfo.model_name.human}" }
        format.json { head :no_content }
      end
    end
  end

  def download_media_info
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

    data = FashionMediaInfo.where([sql]+sql_attr)
    new_file = FashionMediaInfo.create_new_template(data)
    send_file new_file, :type => "application/octet-stream", :disposition => "attachment"
  end

  def upload_media_info
    if request.post?
      if params[:excel_file].blank?
        render :text => "<script>alert('请选择上传的文件!');history.go(-1);</script>"
      else
        if %w(xls).include?(params[:excel_file].original_filename.to_s.split('.')[-1])
          begin
            new_file_name = upload_file(params[:excel_file], "/public/files/temp/")
            workbook = Spreadsheet.open("#{Rails.root}/public/files/temp/"+new_file_name)

            _sheet = workbook.worksheet(0)
            error_numbers = FashionMediaInfo.create_by_excel(_sheet,current_user)
            FileUtils.rm Dir["#{Rails.root}/public/files/temp/*.xls"]
            if error_numbers.count>0
              respond_to do |format|
                format.html { redirect_to fashion_media_infos_path, alert: "上传失败，失败编号为#{error_numbers.join(",")}。请检查城市是否填写正确！！！" }
                format.json { render json: {}, status: :created, location: {} }
              end
            else
              respond_to do |format|
                format.html { redirect_to fashion_media_infos_path, notice: "上传完成，共上传数据#{(_sheet.count)-1}条！！！" }
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
