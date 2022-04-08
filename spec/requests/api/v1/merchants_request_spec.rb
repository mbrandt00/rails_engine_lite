require 'rails_helper'

describe "Merchant API" do
  it "will return all merchants" do
        create_list(:merchant, 5)
        get '/api/v1/merchants'
        expect(response).to be_successful
        merchants = JSON.parse(response.body, symbolize_names: true) 

        expect(merchants[:data].count).to eq(5)

        merchants[:data].each do |merchant|
            expect(merchant[:attributes]).to have_key(:name)
            expect(merchant[:attributes][:name]).to be_a(String)
        end
    end
    it 'will return a single merchant' do 
        merchants = create_list(:merchant, 5)
        get "/api/v1/merchants/#{merchants.first.id}"
        expect(response).to be_successful
        merchant = JSON.parse(response.body, symbolize_names: true)
        expect(merchant[:data][:attributes]).to have_key(:name)
        expect(merchant[:data][:attributes][:name]).to be_a(String)
    end
    it 'will return all items that a merchant has' do 
        merchants = create_list(:merchant, 5)
        merchant_1_items = 4.times do 
            create(:item, merchant_id: merchants.first.id)
        end
        merchant_2_items = 8.times do 
            create(:item, merchant_id: merchants.second.id)
        end
        get "/api/v1/merchants/#{merchants.first.id}/items"
        expect(response).to be_successful
        merchant_items = JSON.parse(response.body, symbolize_names: true)
        expect(merchant_items[:data].count).to eq(4)
        merchant_items[:data].each do |item|
            expect(item[:attributes]).to have_key(:name)
            expect(item[:attributes][:name]).to be_a(String)
            expect(item[:attributes]).to have_key(:description)
            expect(item[:attributes][:description]).to be_a(String)
            expect(item[:attributes]).to have_key(:unit_price)
            expect(item[:attributes][:unit_price]).to be_a(Integer)
            expect(item[:attributes]).to have_key(:merchant_id)
            expect(item[:attributes][:merchant_id]).to be_a(Integer)
            expect(Merchant.find(item[:attributes][:merchant_id])).to be_a(Merchant)
        end
    end
end