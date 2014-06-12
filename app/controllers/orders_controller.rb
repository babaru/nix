class OrdersController < ApplicationController
  before_filter :has_login
  #add_breadcrumb(I18n.t('model.list', model: Order.model_name.human), :orders_path, except: :index)


  def index
    if params[:first_selected_medium_id].blank?
      @orders_grid = initialize_grid(Order.joins(:supplier))
    else
      _ids ,_s_ids = [0],[0]
      @f_cat = BusinessCategory.find_by_id(params[:first_selected_medium_id].to_i)
      @second_categories = @f_cat.children unless @f_cat.blank?
      @s_cat = BusinessCategory.find_by_id(params[:second_selected_medium_id].to_i)

      _ids = @f_cat.cat_ids unless @f_cat.blank?
      _ids = @s_cat.cat_ids unless @s_cat.blank?
      @orders_grid = initialize_grid(Order.joins(:supplier).where('business_category_id in (?)',_ids))
    end
    @first_categories = BusinessCategory.first_categories


    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @orders_grid }
    end
  end

  def new
    @order = Order.new({:project_id=>params[:project_id]})
    @project=@order.project
    @suppliers = []
    @specs = BusinessCategory.specs
    add_breadcrumb(I18n.t('model.list', model: Client.model_name.human), :clients_path)
    add_breadcrumb("#{@project.client.name} #{t('model.list', model: Project.model_name.human)}",client_projects_path(@project.client))
    add_breadcrumb("#{@project.name}",project_path(@project))
    add_breadcrumb("添加订单")
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @order }
    end
  end

  def create
    params[:order][:created_by] = current_user.id
    params[:order][:updated_by] = current_user.id
    @order = Order.new(params[:order])
    respond_to do |format|
      Client.transaction do
        if @order.save
          format.html { redirect_to project_path(@order.project), notice: 'Order was successfully created.' }
          format.json { render json: @order, status: :created, location: @order }
        else
          @project=@order.project
          @specs = BusinessCategory.specs
          @suppliers = Supplier.where('business_category_id = ?',@order.business_category_id)
          add_breadcrumb(I18n.t('model.list', model: Client.model_name.human), :clients_path)
          add_breadcrumb("#{@project.client.name} #{t('model.list', model: Project.model_name.human)}",client_projects_path(@project.client))
          add_breadcrumb("#{@project.name}",project_path(@project))
          format.html { render action: "new" }
          format.json { render json: @order.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def edit
    @order = Order.find_by_id(params[:id])
    @project=@order.project
    @suppliers = Supplier.where('business_category_id = ?',@order.business_category_id)
    @specs = BusinessCategory.specs
    add_breadcrumb(I18n.t('model.list', model: Client.model_name.human), :clients_path)
    add_breadcrumb("#{@project.client.name} #{t('model.list', model: Project.model_name.human)}",client_projects_path(@project.client))
    add_breadcrumb("#{@project.name}",project_path(@project))
    add_breadcrumb("编辑订单")
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @order }
    end
  end

  def update
    @order = Order.find(params[:id])
    params[:order][:updated_by] = current_user.id
    respond_to do |format|
      Client.transaction do
        @order.attributes = params[:order]
        if @order.save
          format.html { redirect_to project_path(@order.project), notice: 'Order was successfully updated.' }
          format.json { render json: @order, status: :created, location: @order }
        else
          @project=@order.project
          @specs = BusinessCategory.specs
          @suppliers = Supplier.where('business_category_id = ?',@order.business_category_id)
          add_breadcrumb(I18n.t('model.list', model: Client.model_name.human), :clients_path)
          add_breadcrumb("#{@project.client.name} #{t('model.list', model: Project.model_name.human)}",client_projects_path(@project.client))
          add_breadcrumb("#{@project.name}",project_path(@project))
          format.html { render action: "edit" }
          format.json { render json: @order.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def destroy
    @order = Order.find(params[:id])
    @order.destroy

    respond_to do |format|
      format.html { redirect_to project_path(id:@order.project_id,selected_id:@order.business_category_id), notice: "Order was successfully deleted." }
      format.json { head :no_content }
    end
  end



  def ajax_get_suppliers
    txt = "<option value='' ></option>"
    _suppliers = Supplier.where('business_category_id = ?',params[:id])
    unless _suppliers.blank?
      _suppliers.each do |s|
        txt  = txt + "<option value='#{s.id}'>#{s.contact_name}#{'('+s.name+')' unless s.name.blank?}</option>"
      end
    end

    render :text => txt
  end

  def finish
    @order = Order.find params[:id]

    if request.post?
      @order.finish!

      respond_to do |format|
        format.html { redirect_to project_path(id:@order.project_id,selected_id:@order.business_category_id), notice: "订单 #{@order.name} 完成" }
        format.json { head :no_content }
      end
    end
  end
end
