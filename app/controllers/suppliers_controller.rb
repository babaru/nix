class SuppliersController < ApplicationController
  before_filter :has_login
	add_breadcrumb(I18n.t('model.list', model: Supplier.model_name.human), :suppliers_path)

  def index
    if params[:first_selected_medium_id].blank?
      @suppliers = initialize_grid(Supplier)
    else
      _ids ,_s_ids = [0],[0]
      params[:second_selected_medium_id]
      @f_cat = BusinessCategory.find_by_id(params[:first_selected_medium_id].to_i)
      @second_categories = @f_cat.children unless @f_cat.blank?
      @s_cat = BusinessCategory.find_by_id(params[:second_selected_medium_id].to_i)

      _ids = @f_cat.cat_ids unless @f_cat.blank?
      _ids = @s_cat.cat_ids unless @s_cat.blank?
      _bs = BusinessCategorySupplier.where('business_category_id in (?)',_ids)
      _s_ids = _bs.map{|b| b.supplier_id} unless _bs.blank?
      @suppliers = initialize_grid(Supplier.where('id in (?)',_s_ids))
    end
    @first_categories = BusinessCategory.first_categories

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @suppliers }
    end
  end

  def destroy
    @supplier = Supplier.find(params[:id])
    @supplier.destroy
    @supplier.business_categories = []

    respond_to do |format|
      format.html { redirect_to suppliers_path, notice: 'Supplier was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  def edit
    @supplier = Supplier.find(params[:id])
    @categories = BusinessCategory.second_categories
  end

  def update

   @supplier = Supplier.find(params[:id])
   @categories = BusinessCategory.second_categories
   params[:supplier][:updated_by]=current_user.id
    respond_to do |format|
      if @supplier.update_attributes(params[:supplier])
        unless params[:supplier_price].blank?
          params[:supplier_price].each do |k,v|
            BusinessCategorySupplier.update_all("price='#{v}'",['business_category_id=? and supplier_id=?',k.to_i,@supplier.id])
          end
        end
        format.html { redirect_to suppliers_path(), notice: 'Supplier was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @supplier.errors, status: :unprocessable_entity }
      end
    end
  end

  def new
    @supplier = Supplier.new
    @categories = BusinessCategory.second_categories
    params[:supplier] ||={}
    params[:supplier][:business_category_ids] ||= [0]
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @supplier }
    end
  end

  def show
    @supplier = Supplier.find(params[:id])
    @order_info = @supplier.get_order_info(params[:selected_id].to_i)
    _f_cat = @supplier.business_categories.first
    params[:selected_id] ||= _f_cat.id unless _f_cat.blank?
    @orders_grid = initialize_grid(Order.where('supplier_id = ? and business_category_id = ?',@supplier.id,params[:selected_id].to_i).order('is_finished asc'))
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @supplier }
    end
  end

  def create
    params[:supplier][:created_by]=current_user.id
    params[:supplier][:updated_by]=current_user.id
    @categories = BusinessCategory.second_categories
    @supplier = Supplier.new(params[:supplier])

    respond_to do |format|
      if @supplier.save
        unless params[:supplier_price].blank?
          params[:supplier_price].each do |k,v|
            BusinessCategorySupplier.update_all("price='#{v}'",['business_category_id=? and supplier_id=?',k.to_i,@supplier.id])
          end
        end
        format.html { redirect_to suppliers_path(), notice: '供应商已成功创建.' }
        format.json { render json: @supplier, status: :created, location: @supplier }
      else
        format.html { render action: "new" }
        format.json { render json: @supplier.errors, status: :unprocessable_entity }
      end
    end
  end

  def upload_spot_plan
    if request.post?
      if params[:supplier_excel_file].blank?
        render :text => "<script>alert('请选择上传的文件!');history.go(-1);</script>"
      else
        if %w(xls).include?(params[:supplier_excel_file].original_filename.to_s.split('.')[-1])
          begin
            new_file_name = upload_file(params[:supplier_excel_file], "/public/files/temp/")
            workbook = Spreadsheet.open("#{Rails.root}/public/files/temp/"+new_file_name)

            supplier_sheet = workbook.worksheet(0)
            Supplier.create_suppliers_by_excel(supplier_sheet,current_user)
            FileUtils.rm Dir["#{Rails.root}/public/files/temp/*.xls"]
            respond_to do |format|
              format.html { redirect_to suppliers_path(), notice: '供应商上传成功.' }
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

  def generate_spot_plan_template
    new_file = Supplier.create_new_template()
    send_file new_file, :type => "application/octet-stream", :disposition => "attachment"
  end

  def generate_spot_plan
    if params[:first_selected_medium_id].blank?
      @suppliers = Supplier.all()
    else
      _ids ,_s_ids = [0],[0]
      params[:second_selected_medium_id]
      @f_cat = BusinessCategory.find_by_id(params[:first_selected_medium_id].to_i)
      @second_categories = @f_cat.children unless @f_cat.blank?
      @s_cat = BusinessCategory.find_by_id(params[:second_selected_medium_id].to_i)

      _ids = @f_cat.cat_ids unless @f_cat.blank?
      _ids = @s_cat.cat_ids unless @s_cat.blank?
      _bs = BusinessCategorySupplier.where('business_category_id in (?)',_ids)
      _s_ids = _bs.map{|b| b.supplier_id} unless _bs.blank?
      @suppliers = Supplier.where('id in (?)',_s_ids)
    end
    new_file = Supplier.create_new_template(@suppliers)
    send_file new_file, :type => "application/octet-stream", :disposition => "attachment"
  end
end
