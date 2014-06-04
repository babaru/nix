class SpecificationsController < ApplicationController
  def new
    @specification = Specification.new
    @categories = BusinessCategory.where('parent_id>0')

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @specification}
    end
  end

  def create
    @specification = Specification.new(params[:specification])
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
