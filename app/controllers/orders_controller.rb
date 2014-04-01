class OrdersController < ApplicationController
  before_filter :has_login
  add_breadcrumb(I18n.t('model.list', model: Order.model_name.human), :orders_path, except: :index)


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
    @order = Order.new()
    @order.project_id = params[:project_id] unless params[:project_id].blank?
    @projects = Project.all()
    @projects ||= []
    @suppliers = []
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @order }
    end
  end

  def edit
    @order = Order.find_by_id(params[:id])
    @projects = Project.all()
    @projects ||= []
    bs = BusinessCategory.find_by_id(@order.business_category_id)
    @suppliers = []
    @suppliers = bs.suppliers unless bs.blank?
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
        if @order.update_attributes(params[:order])
          format.html { redirect_to project_path(id:@order.project_id,selected_id:@order.business_category_id), notice: 'Order was successfully updated.' }
          format.json { render json: @order, status: :created, location: @order }
        else
          bs = BusinessCategory.find_by_id(params[:order][:business_category_id])
          @suppliers = []
          @suppliers = bs.suppliers unless bs.blank?
          format.html { render action: "new" }
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

  def create
    params[:order][:created_by] = current_user.id
    params[:order][:updated_by] = current_user.id
    @order = Order.new(params[:order])
    @projects = Project.all()
    @projects ||= []
    respond_to do |format|
      Client.transaction do
        if @order.save
          format.html { redirect_to project_path(id:@order.project_id,selected_id:@order.business_category_id), notice: 'Order was successfully created.' }
          format.json { render json: @order, status: :created, location: @order }
        else
          bs = BusinessCategory.find_by_id(params[:order][:business_category_id])
          @suppliers = []
          @suppliers = bs.suppliers unless bs.blank?
          format.html { render action: "new" }
          format.json { render json: @order.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def ajax_get_suppliers
    txt = "<option value='' ></option>"
    bs = BusinessCategory.find_by_id(params[:id])
    _suppliers = []
    _suppliers = bs.suppliers unless bs.blank?
    _suppliers.each do |s|
      txt  = txt + "<option value='#{s.id}'>#{s.contact_name}#{'('+s.name+')' unless s.name.blank?}</option>"
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
