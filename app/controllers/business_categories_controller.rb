class BusinessCategoriesController < ApplicationController
  before_filter :has_login
		add_breadcrumb(I18n.t('model.list', model: BusinessCategory.model_name.human), :business_categories_path)

  def index
    @business_categories = initialize_grid(BusinessCategory)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @business_categories }
    end
  end

  def new
    @business_category = BusinessCategory.new
    @first_categories = BusinessCategory.where('parent_id=0')

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @business_category}
    end
  end

  def edit
    @business_category = BusinessCategory.find(params[:id])
    @first_categories = BusinessCategory.where('parent_id=0')
  end

  def update
    @first_categories = BusinessCategory.where('parent_id=0')
    @business_category = BusinessCategory.find(params[:id])
    params[:business_category][:updated_by]=current_user.id
    respond_to do |format|
      if @business_category.update_attributes(params[:business_category])
        format.html { redirect_to business_categories_path(), notice: 'BusinessCategory was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @business_category.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @business_category = BusinessCategory.find(params[:id])
    @business_category.destroy
    Specification.delete_all('business_category_id=?',@business_category.id)
    respond_to do |format|
      format.html { redirect_to business_categories_path }
      format.json { head :no_content }
    end
  end

  def create
    params[:business_category][:created_by]=current_user.id
    params[:business_category][:updated_by]=current_user.id
    @first_categories = BusinessCategory.where('parent_id=0')
    @business_category = BusinessCategory.new(params[:business_category])

    respond_to do |format|
      if @business_category.save
       
        format.html { redirect_to business_categories_path(), notice: '业务类别已成功创建.' }
        format.json { render json: @business_category, status: :created, location: @business_category }
      else
        format.html { render action: "new" }
        format.json { render json: @business_category.errors, status: :unprocessable_entity }
      end
    end
  end
end
