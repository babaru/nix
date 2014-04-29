class FileCategoriesController < ApplicationController

  before_filter :has_login
  add_breadcrumb(I18n.t('model.list', model: FileCategory.model_name.human), :file_categories_path, except: :index)
  def index
    @project = Project.find(params[:project_id])
    @categories = FileCategory.where(:project_id => params[:project_id].to_i,:deleted => 0,:parent_id => 0)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @categories }
    end
  end

  def ajax_add_category
    c = FileCategory.new()
    c.updated_by = current_user.id
    c.created_by = current_user.id
    c.project_id = params[:project_id].to_i
    c.parent_id = params[:id].to_i
    c.category_name = params[:category_name]
    if c.save
      render :text => '添加成功！'
    else
      render :text => '添加失败！'
    end
  end

  def ajax_show_item
    txt = '<ul>'
    _categories = FileCategory.where(:deleted=>0,:parent_id => params[:id].to_i,:project_id => params[:project_id].to_i)
    unless _categories.blank?
      _categories.each do |c|
        txt +="<li id='cat_"+c.id.to_s+"'><a href='#' onclick='show_item("+c.id.to_s+","+params[:project_id].to_s+"); return false;'>"+c.category_name+"</a>&nbsp;&nbsp;&nbsp;&nbsp;<a href='#' onclick='show_add_category("+c.id.to_s+"); return false;'>添加子类</a>&nbsp;&nbsp;&nbsp;&nbsp;<a href='#' onclick='show_upload("+c.id.to_s+",this); return false;'>上传文件</a></li>"
      end
    end
    _files = ProjectFile.where(:deleted => 0,:project_id => params[:project_id].to_i,:file_category_id => params[:id].to_i)
    unless _files.blank?
      _files.each do |f|
        txt += "<li>"+f.file_name+"</li>"
      end

    end
    txt+='</ul>'
    render :text => txt
  end

  def upload_file_category
    if request.post?
      if params[:excel_file].blank?
        render :text => "<script>alert('请选择上传的文件!');history.go(-1);</script>"
      else
        begin
          temp_folder_name = Rails.root.to_s + "/public/files/file_categories/"
          unless File.exist?(temp_folder_name)
            FileUtils.mkdir_p(temp_folder_name)
          end
          old_file_name = params[:excel_file].original_filename
          new_file_name = upload_file(params[:excel_file], "/public/files/file_categories/")
          project = Project.find(params[:hid_project_id])
          f = ProjectFile.new(:deleted=>0)
          f.project_id =  params[:hid_project_id].to_i
          f.file_category_id =  params[:hid_upload_category_id].to_i
          f.file_name =  old_file_name
          f.save_name =  new_file_name
          f.created_by =  current_user.id
          f.updated_by =  current_user.id
          f.save
          redirect_to project_file_categories_path(project), notice: '上传成功.'
        rescue Exception => e
          ActiveRecord::Rollback
          render :text => "<script>alert('#{e.to_s}');history.go(-1);</script>"
          return
        end
      end
    end
  end
end
