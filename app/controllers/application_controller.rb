class ApplicationController < ActionController::Base
  # layout :layout_by_resource
before_filter :set_charset
  protect_from_forgery
  #add_breadcrumb '控制台', '/'

	def set_charset
		headers["Content-Type"] = "text/html; charset=utf8"
		response.headers["Content-Type"] = "text/html; charset=utf8"
		suppress(ActiveRecord::StatementInvalid) do
		ActiveRecord::Base.connection.execute 'SET NAMES utf8'
		end
	end
	def has_login
	    if current_user.blank?
	    	respond_to do |format|
			    format.html { redirect_to '/users/sign_in', alert: '请先登陆.' }
			    format.json { head :no_content }
			end   
	    end
  	end
  	def upload_file(file, path, new_filename=nil) #处理上传后的文件保存
	    return nil if file.blank?
	    path = Rails.root.to_s + path
	    path+="/" unless path.end_with?("/")
	    FileUtils.mkdir_p(path) unless File.exist?(path)
	    unless file.original_filename.empty?
	      #生成一个随机的文件名
	      new_filename = Time.now.strftime("%Y-%m-%d %H:%M:%S").gsub(":", "-").gsub(" ", "-")+"-#{rand(10000)}" + "." + get_extname(file.original_filename) if new_filename.blank?
	      #向dir目录写入文件
	      File.open("#{path+new_filename}", "wb") do |f|
	        f.write(file.read)
	      end
	      #返回文件名称
	      new_filename
	    end
    end
    def get_extname(filename) #获取文件名
	    unless filename.blank?
	      if filename =~ /\.(\w+)$/m
	        $1
	      else
	        ""
	      end
	    end
    end
end
