class NetworkOpinionLeaderBloggersController < ApplicationController

  before_filter :has_login
  add_breadcrumb(I18n.t('model.list', model: NetworkOpinionLeaderBlogger.model_name.human), :network_opinion_leader_bloggers_path, except: :index)
  def index
    sql,sql_attr=' deleted=0',[]

    unless params[:nickname].blank?
      sql += " and nickname like ? "
      sql_attr << "%"+params[:nickname]+"%"
    end

    unless params[:name].blank?
      sql += " and name like ? "
      sql_attr << "%"+params[:name]+"%"
    end

    unless params[:sex].blank?
      sql += " and sex = ? "
      sql_attr << params[:sex].to_i
    end

    unless params[:media_name].blank?
      sql += " and media_name like ? "
      sql_attr << "%"+params[:media_name]+"%"
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

    unless params[:birthday_start].blank?
      sql += " and birthday >= ?"
      sql_attr << params[:birthday_start]
    end

    unless params[:birthday_end].blank?
      sql += " and birthday <= ?"
      sql_attr << params[:birthday_end]
    end

    unless params[:blog_traffic].blank?
      sql += " and blog_traffic >= ? "
      sql_attr << params[:blog_traffic].to_f
    end

    unless params[:blog_traffic1].blank?
      sql += " and blog_traffic <= ? "
      sql_attr << params[:blog_traffic1].to_f
    end

    @medias_grid = initialize_grid(NetworkOpinionLeaderBlogger.where([sql]+sql_attr))
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @medias_grid }
    end
  end

  def new
    @media = NetworkOpinionLeaderBlogger.new()
    @media.created_by = current_user.id
    @cities = City.all(:order=>'province_id asc')

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @media }
    end
  end

  def create
    @media = NetworkOpinionLeaderBlogger.new(params[:network_opinion_leader_blogger])

    #@project.assigned_users << current_user
    @media.updated_by = current_user.id
    @media.created_by = current_user.id

    respond_to do |format|
      if @media.other_valid? and @media.save
        format.html { redirect_to network_opinion_leader_bloggers_path, notice: "成功创建#{TravelingPhotographyMediaInfo.model_name.human}" }
        format.json { render json: @media, status: :created, location: @media }
      else
        @cities = City.all(:order=>'province_id asc')
        format.html { render action: "new" }
        format.json { render json: @media.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @media = NetworkOpinionLeaderBlogger.find(params[:id])
    @cities = City.all(:order=>'province_id asc')
  end

  def update
    @media = NetworkOpinionLeaderBlogger.find(params[:id])
    @media.updated_by = current_user.id
    respond_to do |format|
      if @media.update_attributes(params[:network_opinion_leader_blogger])
        format.html { redirect_to network_opinion_leader_bloggers_path, notice: "成功修改#{NetworkOpinionLeaderBlogger.model_name.human}" }
        format.json { head :no_content }
      else
        @cities = City.all(:order=>'province_id asc')
        format.html { render action: "edit" }
        format.json { render json: @media.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @media = NetworkOpinionLeaderBlogger.find(params[:id])
    @media.deleted=1

    if @media.save
      respond_to do |format|
        format.html { redirect_to network_opinion_leader_bloggers_path, notice: "成功删除#{TravelingPhotographyMediaInfo.model_name.human}" }
        format.json { head :no_content }
      end
    end
  end

  def download_network_opinion_leader_blogger
    sql,sql_attr=' deleted=0',[]

    unless params[:nickname].blank?
      sql += " and nickname like ? "
      sql_attr << "%"+params[:nickname]+"%"
    end

    unless params[:name].blank?
      sql += " and name like ? "
      sql_attr << "%"+params[:name]+"%"
    end

    unless params[:sex].blank?
      sql += " and sex = ? "
      sql_attr << params[:sex].to_i
    end

    unless params[:media_name].blank?
      sql += " and media_name like ? "
      sql_attr << "%"+params[:media_name]+"%"
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

    unless params[:birthday_start].blank?
      sql += " and birthday >= ?"
      sql_attr << params[:birthday_start]
    end

    unless params[:birthday_end].blank?
      sql += " and birthday <= ?"
      sql_attr << params[:birthday_end]
    end

    unless params[:blog_traffic].blank?
      sql += " and blog_traffic >= ? "
      sql_attr << params[:blog_traffic].to_f
    end

    unless params[:blog_traffic1].blank?
      sql += " and blog_traffic <= ? "
      sql_attr << params[:blog_traffic1].to_f
    end


    data = NetworkOpinionLeaderBlogger.where([sql]+sql_attr)
    new_file = NetworkOpinionLeaderBlogger.create_new_template(data)
    send_file new_file, :type => "application/octet-stream", :disposition => "attachment"
  end

  def upload_network_opinion_leader_blogger
    if request.post?
      if params[:excel_file].blank?
        render :text => "<script>alert('请选择上传的文件!');history.go(-1);</script>"
      else
        if %w(xls).include?(params[:excel_file].original_filename.to_s.split('.')[-1])
          begin
            new_file_name = upload_file(params[:excel_file], "/public/files/temp/")
            workbook = Spreadsheet.open("#{Rails.root}/public/files/temp/"+new_file_name)

            _sheet = workbook.worksheet(0)
            NetworkOpinionLeaderBlogger.create_by_excel(_sheet,current_user)
            FileUtils.rm Dir["#{Rails.root}/public/files/temp/*.xls"]
            respond_to do |format|
              format.html { redirect_to network_opinion_leader_bloggers_path, notice: '上传成功.' }
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
