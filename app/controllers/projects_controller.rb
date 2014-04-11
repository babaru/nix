class ProjectsController < ApplicationController
  before_filter :has_login
  add_breadcrumb(I18n.t('model.list', model: Client.model_name.human), :clients_path, only: :index)

  # GET /projects
  # GET /projects.json
  def index
    @client = Client.find params[:client_id]
    add_breadcrumb("#{@client.name} #{t('model.list', model: Project.model_name.human)}")
    @projects_grid = initialize_grid(Project.where(client_id: params[:client_id]))

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @projects_grid }
    end
  end

  # GET /projects/new
  # GET /projects/new.json
  def new
    @project = Project.new
    @project.client_id = params[:client_id]
    @project.created_by = current_user.id


    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @project }
    end
  end

  def show
    @project = Project.find(params[:id])
    _orders = @project.orders
    _orders ||= []
    _cat_ids =  _orders.map{|o|o.business_category_id}
    _cat_ids ||= [0]
    @order_info = @project.get_order_info(params[:selected_id].to_i)
    @business_categories = BusinessCategory.where('id in (?)',_cat_ids.uniq)
    params[:selected_id] ||= @business_categories.first.id unless @business_categories.blank?
    @orders_grid = initialize_grid(Order.where('project_id = ? and business_category_id = ?',@project.id,params[:selected_id].to_i).order('is_finished asc'))
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @project }
    end
  end

  # GET /projects/1/edit
  def edit
    @project = Project.find(params[:id])
    add_breadcrumb("#{@project.client.name} #{t('model.list', model: Project.model_name.human)}", client_projects_path(client_id: @project.client_id))
    add_breadcrumb(t('model.edit', model: Project.model_name.human))
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(params[:project])
    #@project.assigned_users << current_user
    @project.updated_by = current_user.id
    respond_to do |format|
      if @project.valid1? and @project.save
        format.html { redirect_to client_projects_path(client_id: @project.client_id), notice: "成功创建#{Project.model_name.human}" }
        format.json { render json: @project, status: :created, location: @project }
      else
        format.html { render action: "new" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def assign_user
    @project = Project.find params[:id]
    @client = @project.client
  end

  def save_project_users
    @project = Project.find(params[:id])
    if request.post?
      respond_to do |format|
        if @project.update_attributes(params[:project])
          format.html { redirect_to client_projects_path(@project.client), notice: "客户执行人员保存成功！" }
          format.json { head :no_content }
        else
          format.html { render action: "assigns" }
          format.json { render json: @project.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    @project = Project.find(params[:id])
    @project.updated_by = current_user.id
    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html { redirect_to client_projects_path(client_id: @project.client_id), notice: "成功修改#{Project.model_name.human}" }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project = Project.find(params[:id])
    client_id = @project.client_id
    @project.destroy

    respond_to do |format|
      format.html { redirect_to client_projects_path(client_id), notice: "成功删除#{Project.model_name.human}" }
      format.json { head :no_content }
    end
  end

  def start
    @project = Project.find params[:id]

    if request.post?
      @project.start!

      respond_to do |format|
        format.html { redirect_to client_projects_path(@project.client_id), notice: "项目 #{@project.name} 启动成功" }
        format.json { head :no_content }
      end
    end
  end

  def download_project_info
    @project = Project.find params[:id]
    new_file = Project.create_new_template(@project)
    send_file new_file, :type => "application/octet-stream", :disposition => "attachment"
  end
end
