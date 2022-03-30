class Merchant < ApplicationRecord
    has_many :items

    def self.find_merchant(string)
        where("name ilike ?", "%#{string}%").order(:name).first
    end

    def self.find_all_merchants(string)
        where("name ilike ?", "%#{string}%").order(:name)
    end
end