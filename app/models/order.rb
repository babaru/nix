class Order < ActiveRecord::Base
  attr_accessible :name, :business_category_id, :supplier_id, :project_id, :price, :notes,:updated_by,:created_by
  validates :name, presence: true
  validates :business_category_id, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :supplier_id, presence: true
  validates :project_id, presence: true
  belongs_to :supplier
  belongs_to :business_category
  belongs_to :project
  belongs_to :created_man, :class_name => "User", :foreign_key => "created_by"
  belongs_to :updated_man, :class_name => "User", :foreign_key => "updated_by"

  def created_name
    self.created_man.blank? ? '' : self.created_man.name
  end
  def updated_name
    self.updated_man.blank? ? '' : self.updated_man.name
  end
  def is_finished?
    self.is_finished.to_i==1
  end
  def finish!
    if self.is_finished.to_i == 0
      self.is_finished = 1
      self.finished_at = Time.now
      self.save!
    end
  end
end
