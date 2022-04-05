class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items
  validates :merchant_id, numericality: true
  validates :unit_price, numericality: true
  validates_presence_of :name, :description, :unit_price, :merchant_id

  def self.find_all_items_name(string)
    where('name ilike ?', "%#{string}%").order(:name)
  end

  def self.find_item_name((string))
    where('name ilike ?', "%#{string}%").order(:name).first
  end

  def self.find_matching_item(min, max)
    if !max.nil?
      items = Item.where('unit_price <= ?', max)
      items = items.where('unit_price >= ?', min) unless min.nil?
    elsif !min.nil?
      items = Item.where('unit_price >= ?', min)
    end
    items.order(:name)
  end
end
