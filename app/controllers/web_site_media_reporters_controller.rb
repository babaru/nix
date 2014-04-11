class WebSiteMediaReportersController < ApplicationController
  before_filter :has_login
  add_breadcrumb(I18n.t('model.list', model: WebSiteMediaReporter.model_name.human), :web_site_media_reporters_path, only: :index)


  def index
    @reporters_grid = initialize_grid(WebSiteMediaReporter.where(:deleted=>0))

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @reporters_grid }
    end
  end

  def new
    @reporter = WebSiteMediaReporter.new
    @reporter.created_by = current_user.id
    @regions=Region.all() || []
    @provinces = Province.where(:region_id => @regions.first().id) unless @regions.blank?
    @cities = City.where(:province_id => @provinces.first().id) unless @provinces.blank?

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @reporter }
    end
  end

  def create
    @reporter = WebSiteMediaReporter.new(params[:web_site_media_reporter])

    #@project.assigned_users << current_user
    @reporter.updated_by = current_user.id
    @reporter.created_by = current_user.id
    respond_to do |format|
      if @reporter.other_valid? and @reporter.save
        format.html { redirect_to web_site_media_reporters_path, notice: "成功创建#{WebSiteMediaReporter.model_name.human}" }
        format.json { render json: @reporter, status: :created, location: @reporter }
      else
        format.html { render action: "new" }
        format.json { render json: @reporter.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @reporter = WebSiteMediaReporter.find(params[:id])
    @regions=Region.all() || []
    @provinces = Province.where(:region_id => @reporter.region_id) unless @regions.blank?
    @cities = City.where(:province_id => @reporter.province_id) unless @provinces.blank?
  end

  def update
    @reporter = WebSiteMediaReporter.find(params[:id])
    @reporter.updated_by = current_user.id
    respond_to do |format|
      if @reporter.update_attributes(params[:web_site_media_reporter])
        format.html { redirect_to web_site_media_reporters_path, notice: "成功修改#{WebSiteMediaReporter.model_name.human}" }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @reporter.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @reporter = WebSiteMediaReporter.find(params[:id])
    @reporter.deleted=1

    if @reporter.save
      respond_to do |format|
        format.html { redirect_to web_site_media_reporters_path, notice: "成功删除#{WebSiteMediaReporter.model_name.human}" }
        format.json { head :no_content }
      end
    end
  end



  def ajax_get_provinces
    txt = ""
    region = Region.find_by_id(params[:id].to_i)
    _provinces = []
    _provinces = region.provinces unless region.blank?
    _provinces.each do |s|
      txt  = txt + "<option value='#{s.id}'>#{s.name}</option>"
    end
    render :text => txt
  end

  def ajax_get_cities
    txt = ""
    province = Province.find_by_id(params[:id].to_i)
    _cities = []
    _cities = province.cities unless province.blank?
    _cities.each do |s|
      txt  = txt + "<option value='#{s.id}'>#{s.name}</option>"
    end
    render :text => txt
  end
end
