require 'rails_helper'

RSpec.describe "Item API" do
    it "will return all Items for all merchants" do
        merchants = create_list(:merchant, 3)
        merchant_1_items = 3.times do 
            create(:item, merchant_id: merchants.first.id)
        end
        merchant_2_items = 2.times do 
            create(:item, merchant_id: merchants.second.id)
        end
        merchant_3_items = 1.times do 
            create(:item, merchant_id: merchants.third.id)
        end
        get '/api/v1/items'
        expect(response).to be_successful
        all_items = JSON.parse(response.body, symbolize_names: true) 
        expect(all_items[:data].count).to eq(6)
        all_items[:data].each do |item|
            expect(item[:attributes]).to have_key(:name)
            expect(item[:attributes][:name]).to be_a(String)
            expect(item[:attributes]).to have_key(:description)
            expect(item[:attributes][:description]).to be_a(String)
            expect(item[:attributes]).to have_key(:unit_price)
            expect(item[:attributes][:unit_price]).to be_a(Integer)
            expect(item[:attributes]).to have_key(:merchant_id)
            expect(item[:attributes][:merchant_id]).to be_an(Integer)
        end
    end
    it 'can get one item' do 
        item = create(:item)
        get "/api/v1/items/#{item.id}"
        expect(response).to be_successful
        item_info = JSON.parse(response.body, symbolize_names: true) 
        item_info = item_info[:data]
        expect(item_info).to be_a(Hash)
        expect(item_info[:attributes]).to have_key(:name)
        expect(item_info[:attributes][:name]).to be_a(String)
        expect(item_info[:attributes]).to have_key(:description)
        expect(item_info[:attributes][:description]).to be_a(String)
        expect(item_info[:attributes]).to have_key(:unit_price)
        expect(item_info[:attributes][:unit_price]).to be_a(Integer)
        expect(item_info[:attributes]).to have_key(:merchant_id)
        expect(item_info[:attributes][:merchant_id]).to be_an(Integer)
    end
    it 'will create a new book' do 
        expect(Item.all.count).to eq(0)
        merchant = create(:merchant)
        post '/api/v1/items', params: {name: 'New Item', description: 'A lovely widget', unit_price: 10.0, merchant_id: merchant.id} 
        expect(Item.all.count).to eq(1)
        
    end
    it 'will return an error if post is not valid' do 
        merchant = create(:merchant)
        # no name
        post '/api/v1/items', params: {description: 'A lovely widget', unit_price: '3', merchant_id: merchant.id}
        response_info = JSON.parse(response.body, symbolize_names: true) 
        expect(response_info).to have_key(:error)
        expect(response_info[:error]).to eq("bad request")
        
    end
    it 'can update an item' do 
        item = create(:item, name: 'Wrong name')
        patch "/api/v1/items/#{item.id}", params: {name: 'Correct name'}
        response_info = JSON.parse(response.body, symbolize_names: true) 
        expect(response_info[:data][:attributes][:name]).to eq('Correct name')
    end
    it 'will return an error if an item cannot be updated because of bad input' do 
        item = create(:item)
        patch "/api/v1/items/#{item.id}", params: {unit_price: 'One thousand dollars'}
        response_info = JSON.parse(response.body, symbolize_names: true) 
        expect(response_info[:error][:unit_price]).to eq(['is not a number'])
    end
    it 'will return an error if the item cannot be valid if its not found' do 
        item = create(:item, name: 'Wrong name')
        put "/api/v1/items/#{item.id+1}", params: {name: 'Correct name'}
        response_info = JSON.parse(response.body, symbolize_names: true)
        expect(response_info[:error]).to eq('not found')

    end
    it 'can delete an item' do 
        item = create(:item, name: 'Wrong name')
        delete "/api/v1/items/#{item.id}"
        expect(Item.all).to eq([])
    end
    it 'can get the merchant information of an item' do 
        merchant = create(:merchant, name: 'Best Buy')
        item = create(:item, name: 'item a', merchant_id: merchant.id)
        get "/api/v1/items/#{item.id}/merchant"
        response_info = JSON.parse(response.body, symbolize_names: true) 
        expect(response_info[:data][:attributes]).to have_key(:name)
        expect(response_info[:data][:attributes][:name]).to eq('Best Buy')
    end
end