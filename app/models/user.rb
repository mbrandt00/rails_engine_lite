class User < ApplicationRecord
    belongs_to :customer, optional: true
    belongs_to :merchant, optional: true
    has_secure_password
    validates_presence_of :email 
    validates_uniqueness_of :email
    enum type_of_user: { customer: 0, merchant: 1, admin: 2 }
    after_create :create_type

    private 
    def create_type
        if type_of_user == 'customer' 
            customer = Customer.create!(first_name: first_name, last_name: last_name)
            self.customer_id = customer.id
            self.save
        elsif type_of_user == 'merchant'
            merchant = Merchant.create!(name: first_name)
            self.merchant_id = merchant.id
            self.save
        end
    end
end
