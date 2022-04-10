require 'factory_bot_rails'

20.times do 
    customers = FactoryBot.create(:user, type_of_user: 0)
    merchants = FactoryBot.create(:user, type_of_user: 1, password: 'admin')
end
1000.times do 
    merchant = Merchant.all.sample(1).first
    FactoryBot.create(:item, merchant: merchant)
end

100.times do 
    customer = Customer.all.sample(1).first 
    FactoryBot.create(:invoice, customer: customer)
end

1000.times do 
    invoice = Invoice.all.sample(1).first 
    rand(1..5).times do 
        item = Item.all.sample(1).first
        FactoryBot.create(:invoice_item, invoice: invoice, item: item)
    end
end