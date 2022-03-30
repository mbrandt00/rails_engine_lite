class Merchant < ApplicationRecord
    has_many :items

    def self.find_merchant(string)
        Merchant.where("lower(name) like ?", "%#{string.downcase!}%").order(:name).first
    end
    def self.find_all_merchants(string)
        Merchant.where("lower(name) like ?", "%#{string.downcase!}%").order
    end
end