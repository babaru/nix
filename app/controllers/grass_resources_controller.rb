class GrassResourcesController < ApplicationController

  before_filter :has_login
  add_breadcrumb(I18n.t('model.list', model: GrassResource.model_name.human), :grass_resources_path, except: :index)


  def index
    sql,sql_attr = 'deleted=0 ',[]
    @f_type,@s_type=nil,nil
    unless params[:type_id].blank?
      sql += ' and type_id = ?'
      sql_attr << params[:type_id].to_i
      @f_type = GrassResource::TYPE.find{|x| x[1] == params[:type_id].to_i}
      unless params[:media_type_id].blank?
        sql += ' and media_type_id = ?'
        sql_attr << params[:media_type_id].to_i
        @s_type = GrassResource::MEDIA_TYPE.find{|x| x[1] == params[:media_type_id].to_i}
      end
    end

    @medias_grid = initialize_grid(GrassResource.where([sql]+sql_attr))
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @medias_grid }
    end
  end

  def new
    @media = GrassResource.new()
    @media.created_by = current_user.id

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @media }
    end
  end

  def create
    @media = GrassResource.new(params[:grass_resource])

    #@project.assigned_users << current_user
    @media.updated_by = current_user.id
    @media.created_by = current_user.id
    @media.deleted = 0

    respond_to do |format|
      if @media.other_valid? and @media.save
        format.html { redirect_to grass_resources_path, notice: "成功创建#{GrassResource.model_name.human}" }
        format.json { render json: @media, status: :created, location: @media }
      else
        format.html { render action: "new" }
        format.json { render json: @media.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @media = GrassResource.find(params[:id])
  end

  def update
    @media = GrassResource.find(params[:id])
    @media.updated_by = current_user.id
    respond_to do |format|
      if @media.update_attributes(params[:grass_resource])
        format.html { redirect_to grass_resources_path, notice: "成功修改#{GrassResource.model_name.human}" }
        format.json { head :no_content }
      else
        @cities = City.all(:order=>'province_id asc')
        format.html { render action: "edit" }
        format.json { render json: @media.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @media = GrassResource.find(params[:id])
    @media.deleted=1

    if @media.save
      respond_to do |format|
        format.html { redirect_to grass_resources_path, notice: "成功删除#{GrassResource.model_name.human}" }
        format.json { head :no_content }
      end
    end
  end

  def download_grass_resource
    sql,sql_attr=' deleted=0 ',[]

    data = GrassResource.where([sql]+sql_attr)
    new_file = GrassResource.create_new_template(data)
    send_file new_file, :type => "application/octet-stream", :disposition => "attachment"
  end

  def download_grass_resource_template
    new_file = GrassResource.create_new_template(nil)
    send_file new_file, :type => "application/octet-stream", :disposition => "attachment"
  end

  def upload_grass_resource
    if request.post?
      if params[:excel_file].blank?
        render :text => "<script>alert('请选择上传的文件!');history.go(-1);</script>"
      else
        if %w(xls).include?(params[:excel_file].original_filename.to_s.split('.')[-1])
          #begin
            new_file_name = upload_file(params[:excel_file], "/public/files/temp/")
            workbook = Spreadsheet.open("#{Rails.root}/public/files/temp/"+new_file_name)

            _sheet = workbook.worksheet(0)
            error_numbers = GrassResource.create_by_excel(_sheet,current_user)
            FileUtils.rm Dir["#{Rails.root}/public/files/temp/*.xls"]
            if error_numbers.count>0
              respond_to do |format|
                format.html { redirect_to grass_resources_path, alert: "上传失败，失败编号为#{error_numbers.join(",")}。请检查数据填写是否正确！！！" }
                format.json { render json: {}, status: :created, location: {} }
              end
            else
              respond_to do |format|
                format.html { redirect_to grass_resources_path, notice: "上传完成！！！" }
                format.json { render json: {}, status: :created, location: {} }
              end
            end
          # rescue Exception => e
          #   ActiveRecord::Rollback
          #   render :text => "<script>alert('#{e.to_s}');history.go(-1);</script>"
          #   return
          # end
        else
          render :text => "<script>alert('格式错误!');history.go(-1);</script>"
        end
      end
    end
  end
end
