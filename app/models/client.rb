class Client < ActiveRecord::Base
  # attr_accessible :title, :body
  validates :name, presence:{message:'名称不能为空'}
  has_many :projects
  has_and_belongs_to_many :users
   attr_accessible :logo, :name, :created_by, :updated_by,:user_ids
   def logo_url
   	if logo.blank?
   		'/files/logo_files/missing.png'
   	else
   		'/files/logo_files/'+self.logo.to_s
   	end
   end
end
