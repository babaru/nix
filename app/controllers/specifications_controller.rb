class SpecificationsController < ApplicationController
  def new
    @specification = BusinessCategory.new
    @categories = BusinessCategory.where('parent_id>0')
    add_breadcrumb(I18n.t('model.list', model: BusinessCategory.model_name.human), :business_categories_path)
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @specification}
    end
  end

  def create
    params[:specification][:created_by] = current_user.id
    params[:specification][:updated_by] = current_user.id
    @specification = BusinessCategory.new(params[:specification])
    return
    respond_to do |format|
      if @specification.save

        format.html { redirect_to business_categories_path(), notice: '类别规格已成功创建.' }
        format.json { render json: @specification, status: :created, location: @specification }
      else
        format.html { render action: "new" }
        format.json { render json: @specification.errors, status: :unprocessable_entity }
      end
    end
  end
end
