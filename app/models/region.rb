class Region < ActiveRecord::Base
  attr_accessible :name
  has_many :provinces

  def self.init_regions
    attr = ['华北地区','东北地区','华东地区','西南地区','中南地区','西北地区','其他地区']
    attr.each do |r|
      Region.create({:name=>r}) 
    end
    puts 'create end ...'
  end
end
