class SuppliersController < ApplicationController
  before_filter :has_login
	add_breadcrumb(I18n.t('model.list', model: Supplier.model_name.human), :suppliers_path)

  def index
    sql,sql_attr=' 1=1 ',[]

    unless params[:name].blank?
      sql += ' and name like ?'
      sql_attr << '%'+params[:name].to_s+'%'
    end

    unless params[:is_personal].blank?
      sql += ' and is_personal = ?'
      sql_attr << params[:is_personal].to_i
    end

    unless params[:contact_name].blank?
      sql += ' and contact_name like ?'
      sql_attr << '%'+params[:contact_name].to_s+'%'
    end

    unless params[:price].blank?
      sql += ' and price >= ?'
      sql_attr << params[:price].to_f
    end

    unless params[:price1].blank?
      sql += ' and price <= ?'
      sql_attr << params[:price1].to_f
    end

    if !params[:avg_score].blank? or !params[:avg_score1].blank?
      ses = SupplierEvaluation.find_by_sql(['select avg(score) as score,supplier_id from supplier_evaluations group by supplier_id'])
      unless params[:avg_score].blank?
        ses = ses.select{|x| x.score.to_f >= params[:avg_score].to_f}
      end

      unless params[:avg_score1].blank?
        ses = ses.select{|x| x.score.to_f <= params[:avg_score1].to_f}
      end
      su_ids = [0]
      su_ids = ses.map{|x|x.supplier_id} unless ses.blank?
      sql += ' and id in (?) '
      sql_attr << su_ids
    end




    if params[:fir_category_select_ids].blank?
      @first_categories = BusinessCategory.first_categories
      params[:sec_category_select_ids]=''
    else
      @f_cats = BusinessCategory.where('id in (?)',params[:fir_category_select_ids].split(','))
      @fir_category_select_name = @f_cats.map{|x| x.name_cn}.join('/')
      if params[:sec_category_select_ids].blank?
        @s_cats = BusinessCategory.where('parent_id in (?)',params[:fir_category_select_ids].split(','))
        _s_cat_ids = [0]
        _s_cat_ids = @s_cats.map{|x| x.id} unless @s_cats.blank?
        @specs = BusinessCategory.where('parent_id in (?)',_s_cat_ids)
        _spce_ids = [0]
        _spce_ids = @specs.map{|x| x.id} unless @specs.blank?
        sql += ' and business_category_id in (?)'
        sql_attr << _spce_ids
        #@suppliers = initialize_grid(Supplier.where(['business_category_id in (?)',_spce_ids]))
      else
        @s_cats = BusinessCategory.where('id in (?)',params[:sec_category_select_ids].split(','))
        @sec_category_select_name = @s_cats.map{|x| x.name_cn}.join('/')
        @specs = BusinessCategory.where('parent_id in (?)',params[:sec_category_select_ids].split(','))
        _spce_ids = [0]
        _spce_ids = @specs.map{|x| x.id} unless @specs.blank?
        sql += ' and business_category_id in (?)'
        sql_attr << _spce_ids
        #@suppliers = initialize_grid(Supplier.where(['business_category_id in (?)',_spce_ids]))
      end
    end
    @suppliers = initialize_grid(Supplier.where([sql]+sql_attr))
    respond_to do |format|
      format.html
      format.json { render json: @suppliers }
    end
  end

  def destroy
    @supplier = Supplier.find(params[:id])
    @supplier.destroy
    @supplier.business_categories = []
    @supplier.specifications = []
    respond_to do |format|
      format.html { redirect_to suppliers_path, notice: 'Supplier was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  def edit
    add_breadcrumb(I18n.t('model.edit', model: Supplier.model_name.human))
    @supplier = Supplier.find(params[:id])
    @clients = Client.all().map{|x| [x.name,x.id]}
    @specs = BusinessCategory.specs
  end

  def update
    params[:supplier][:created_by]=current_user.id
    params[:supplier][:updated_by]=current_user.id
   @supplier = Supplier.find(params[:id])


    respond_to do |format|
      if  @supplier.other_valid? and @supplier.update_attributes(params[:supplier])
        format.html { redirect_to suppliers_path(), notice: 'Supplier was successfully updated.' }
        format.json { head :no_content }
      else
        @clients = Client.all().map{|x| [x.name,x.id]}
        @specs = BusinessCategory.specs
        format.html { render action: "edit" }
        format.json { render json: @supplier.errors, status: :unprocessable_entity }
      end
    end
  end

  def new
    add_breadcrumb(I18n.t('model.create', model: Supplier.model_name.human))
    @supplier = Supplier.new
    @clients = Client.all().map{|x| [x.name,x.id]}
    @specs = BusinessCategory.specs
    params[:supplier] ||={}
    params[:supplier][:specification_ids] ||= [0]
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
    @supplier = Supplier.new(params[:supplier])

    respond_to do |format|
      if @supplier.other_valid? and @supplier.save
        format.html { redirect_to suppliers_path(), notice: '供应商已成功创建.' }
        format.json { render json: @supplier, status: :created, location: @supplier }
      else
        @clients = Client.all().map{|x| [x.name,x.id]}
        @specs = BusinessCategory.specs
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
          #begin
            new_file_name = upload_file(params[:supplier_excel_file], "/public/files/temp/")
            workbook = Spreadsheet.open("#{Rails.root}/public/files/temp/"+new_file_name)

            supplier_sheet = workbook.worksheet(0)
            _error_info = Supplier.create_suppliers_by_excel(supplier_sheet,current_user)
            FileUtils.rm Dir["#{Rails.root}/public/files/temp/*.xls"]
            respond_to do |format|
              if _error_info == ''
                format.html { redirect_to suppliers_path(), notice: '供应商上传成功.' }
                format.json { render json: {}, status: :created, location: {} }
              else
                format.html { redirect_to suppliers_path(), alert: _error_info }
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

  def generate_spot_plan_template
    new_file = Supplier.create_new_template()
    send_file new_file, :type => "application/octet-stream", :disposition => "attachment"
  end

  def generate_spot_plan
    sql,sql_attr=' 1=1 ',[]

    unless params[:name].blank?
      sql += ' and name like ?'
      sql_attr << '%'+params[:name].to_s+'%'
    end

    unless params[:is_personal].blank?
      sql += ' and is_personal = ?'
      sql_attr << params[:is_personal].to_i
    end

    unless params[:contact_name].blank?
      sql += ' and contact_name like ?'
      sql_attr << '%'+params[:contact_name].to_s+'%'
    end

    unless params[:price].blank?
      sql += ' and price >= ?'
      sql_attr << params[:price].to_f
    end

    unless params[:price1].blank?
      sql += ' and price <= ?'
      sql_attr << params[:price1].to_f
    end

    if !params[:avg_score].blank? or !params[:avg_score1].blank?
      ses = SupplierEvaluation.find_by_sql(['select avg(score) as score,supplier_id from supplier_evaluations group by supplier_id'])
      unless params[:avg_score].blank?
        ses = ses.select{|x| x.score.to_f >= params[:avg_score].to_f}
      end

      unless params[:avg_score1].blank?
        ses = ses.select{|x| x.score.to_f <= params[:avg_score1].to_f}
      end
      su_ids = [0]
      su_ids = ses.map{|x|x.supplier_id} unless ses.blank?
      sql += ' and id in (?) '
      sql_attr << su_ids
    end




    if params[:fir_category_select_ids].blank?
      @first_categories = BusinessCategory.first_categories
      params[:sec_category_select_ids]=''
    else
      @f_cats = BusinessCategory.where('id in (?)',params[:fir_category_select_ids].split(','))
      @fir_category_select_name = @f_cats.map{|x| x.name_cn}.join('/')
      if params[:sec_category_select_ids].blank?
        @s_cats = BusinessCategory.where('parent_id in (?)',params[:fir_category_select_ids].split(','))
        _s_cat_ids = [0]
        _s_cat_ids = @s_cats.map{|x| x.id} unless @s_cats.blank?
        @specs = BusinessCategory.where('parent_id in (?)',_s_cat_ids)
        _spce_ids = [0]
        _spce_ids = @specs.map{|x| x.id} unless @specs.blank?
        sql += ' and business_category_id in (?)'
        sql_attr << _spce_ids
        #@suppliers = initialize_grid(Supplier.where(['business_category_id in (?)',_spce_ids]))
      else
        @s_cats = BusinessCategory.where('id in (?)',params[:sec_category_select_ids].split(','))
        @sec_category_select_name = @s_cats.map{|x| x.name_cn}.join('/')
        @specs = BusinessCategory.where('parent_id in (?)',params[:sec_category_select_ids].split(','))
        _spce_ids = [0]
        _spce_ids = @specs.map{|x| x.id} unless @specs.blank?
        sql += ' and business_category_id in (?)'
        sql_attr << _spce_ids
        #@suppliers = initialize_grid(Supplier.where(['business_category_id in (?)',_spce_ids]))
      end
    end
    @suppliers = Supplier.where([sql]+sql_attr)
    new_file = Supplier.create_new_template(@suppliers)
    send_file new_file, :type => "application/octet-stream", :disposition => "attachment"
  end
end
