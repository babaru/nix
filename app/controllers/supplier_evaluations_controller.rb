class SupplierEvaluationsController < ApplicationController
  before_filter :has_login
  add_breadcrumb(I18n.t('model.list', model: Supplier.model_name.human), :suppliers_path)

  def index
    @supplier = Supplier.find(params[:supplier_id])
    add_breadcrumb(@supplier.show_name+'评价列表')
    @supplier_evaluations = initialize_grid(SupplierEvaluation.where('supplier_id = ?',@supplier.id))
  end

  def new
    @supplier = Supplier.find(params[:id])
    add_breadcrumb(@supplier.show_name+'评价列表',supplier_supplier_evaluations_path(@supplier))
    @supplier_evaluation = SupplierEvaluation.new(:supplier_id=>params[:id])
  end

  def create
    params[:supplier_evaluation][:updated_by]=current_user.id
    params[:supplier_evaluation][:created_by]=current_user.id
    @supplier_evaluation = SupplierEvaluation.new(params[:supplier_evaluation])
    respond_to do |format|
      if  @supplier_evaluation.save
        format.html { redirect_to suppliers_path(), notice: 'Supplier was successfully updated.' }
        format.json { head :no_content }
      else
        @supplier = Supplier.find(@supplier_evaluation.supplier_id)
        format.html { render action: "new" }
        format.json { render json: @supplier_evaluation.errors, status: :unprocessable_entity }
      end
    end
  end

end
