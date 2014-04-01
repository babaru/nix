class Project < ActiveRecord::Base
  has_and_belongs_to_many :users
  attr_accessible :name, :budget, :started_at, :ended_at, :client_id, :created_by,:user_ids
  validates :name, presence: true
  validates :budget, presence: true
  validates :budget, numericality: { greater_than: 0 }
  validates :started_at, presence: true
  validates :ended_at, presence: true
  belongs_to :client
  has_many :orders

  scope :started, where(is_started: 1)

  def is_started?
    self.is_started.to_i==1
  end

  def started_at_label
    if self.started_at.blank?
      ''
    else
      self.started_at.strftime('%Y-%m-%d')
    end
  end

  def ended_at_label
    if self.ended_at.blank?
      ''
    else
      self.ended_at.strftime('%Y-%m-%d')
    end
  end

  def get_order_info(selected_id=0)
    info = {}
    _orders = self.orders
    unless _orders.blank?
      _orders.each do |o|
        info[:all_order_price] = info[:all_order_price].to_f+o.price.to_f
        info[:all_order_count] =info[:all_order_count].to_i+1
        if o.business_category_id.to_i == selected_id
          info[:select_order_price] = info[:select_order_price].to_f+o.price.to_f
          info[:select_order_count] =info[:select_order_count].to_i+1
          if o.is_finished?
            info[:select_finished_order_price] = info[:select_finished_order_price].to_f+o.price.to_f
            info[:select_finished_order_count] =info[:select_finished_order_count].to_i+1
          end
        end
        if o.is_finished?
          info[:finished_order_price] =info[:finished_order_price].to_f+ o.price.to_f
          info[:finished_order_count] =info[:finished_order_count].to_i+1
        end
      end
    end
    info
  end

  def valid1?
    if self.started_at and self.ended_at and self.started_at >= self.ended_at
      errors.add(:ended_at,"结束日期不能小于开始日期")
    end
    errors.size == 0
  end

  def start!
    if self.is_started == 0
      self.is_started = 1
      self.is_started_at = Time.now
      self.save!
    end
  end
end
