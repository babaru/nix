class Permission < ActiveRecord::Base
  attr_accessible :action, :subject_class, :subject_id

  def name
    I18n.t("model.#{self.action}", model: self.subject_class.constantize.model_name.human)
  end

  def self.create_permissions

    _models = ['BusinessCategory','Client','Order','Project','Supplier','User',
               'GrassResource','Moderator','WebSiteMediaReporter','FashionMediaInfo','TravelingPhotographyMediaInfo',
               'NetworkOpinionLeaderBlogger','SupplierEvaluation']
    _models.each do |m|
      ['update','create','destroy','read'].each do |item|
        if Permission.where('subject_class= ? and action= ?',m,item).blank?
          _permission = Permission.new()
          _permission.subject_class= m
          _permission.action= item
          _permission.notes= I18n.t("model.#{item}", model: m.constantize.model_name.human)
          _permission.save
        end
      end
    end

  end
end
