class SupplierEvaluationsController < ApplicationController
  before_filter :has_login
  add_breadcrumb(I18n.t('model.list', model: Supplier.model_name.human), :suppliers_path)

  def index
    add_breadcrumb(I18n.t('model.list', model: SupplierEvaluation.model_name.human))
    @supplier = Supplier.find(params[:supplier_id])
    @supplier_evaluations = initialize_grid(SupplierEvaluation.where('supplier_id = ?',@supplier.id))
  end

  def new
    @supplier = Supplier.find(params[:id])
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
