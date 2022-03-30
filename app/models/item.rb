class Item < ApplicationRecord
    belongs_to :merchant
    validates :merchant_id, numericality: true
    validates :unit_price, numericality: true
    validates_presence_of :name, :description, :unit_price, :merchant_id

    def self.find_all_items_name(string)
        Item.where("lower(name) like ?", "%#{string.downcase!}%")
    end
    
    def self.find_item_name((string))
        Item.where("lower(name) like ?", "%#{string.downcase!}%").first
    end

    def self.find_matching_item(min, max)
        if max != nil 
            items = Item.where("unit_price <= ?", max)
            if min != nil 
                items = items.where("unit_price >= ?", min)
            end
        elsif min != nil  
            items = Item.where("unit_price >= ?", min)
        end
        items
    end
  
end