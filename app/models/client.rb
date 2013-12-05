class Client < ActiveRecord::Base
  # attr_accessible :title, :body
   attr_accessible :logo, :name, :created_by, :updated_by
   def logo_url
   	if logo.blank?
   		'/files/logo_files/missing.png'
   	else
   		'/files/logo_files/'+self.logo.to_s
   	end
   end
end
