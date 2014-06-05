class SupplierEvaluationsController < ApplicationController
  before_filter :has_login
  add_breadcrumb(I18n.t('model.list', model: Supplier.model_name.human), :suppliers_path)

  def index
    add_breadcrumb(I18n.t('model.list', model: SupplierEvaluation.model_name.human))
    @supplier = Supplier.find(params[:supplier_id])
    @supplier_evaluations = initialize_grid(SupplierEvaluation)
  end

  def new
    @supplier = Supplier.find(params[:id])
    @specifications = @supplier.specifications
  end

  def create
    @supplier = Supplier.find(params[:id])
    unless params[:data].blank?
      se = SupplierEvaluation.create({:supplier_id=>@supplier.id,:notes=>params[:notes],:created_by=>current_user.id,:updated_by=>current_user.id})
      params[:data].each do |k,v|
        SupplierEvaluationItem.create({:supplier_evaluation_id=>se.id,:specification_id=>k.to_i,:score=>v[0].to_i})
      end
    end
    respond_to do |format|
      format.html { redirect_to supplier_supplier_evaluations_path(@supplier), notice: '评价添加成功！！！.' }
      format.json { head :no_content }
    end
     end

end
