require 'rails_helper'

RSpec.describe 'non-restful' do 
    describe 'merchant querying' do 
        describe '/find' do 
            it 'will find the first merchant object alphabetically that matches a search term ' do 
                create(:merchant, name: 'apple')
                create(:merchant, name: 'aaron')
                get '/api/v1/merchants/find?name=A'
                response_info = JSON.parse(response.body, symbolize_names: true)
                expect(response_info[:data][:attributes][:name]).to eq("aaron")
            end
        end
    end
    describe 'item querying ' do 
        describe '/find' do 
            describe 'name query' do 
                it 'will the first alphabetical item that matches a search term' do
                    create(:item, name: 'apple')
                    create(:item, name: 'banana')
                    get '/api/v1/items/find?name=A'
                    response_info = JSON.parse(response.body, symbolize_names: true)
                    expect(response_info[:data][:attributes][:name]).to eq("apple")
                end
            end
            describe 'price queries' do  
                it 'will return return one item that matches if there is only a min price supplied' do 
                    create(:item, unit_price: 8, name: 'Burrito')
                    create(:item, unit_price: 10, name: 'Burger')
                    create(:item, unit_price: 25, name: 'Steak')
                    get '/api/v1/items/find?min_price=15'
                    response_info = JSON.parse(response.body, symbolize_names: true)
                    expect(response_info[:data][:attributes][:unit_price]).to be > 15
                end
                it 'will return return one item that matches if there is only a max price supplied' do 
                    create(:item, unit_price: 8, name: 'Burrito')
                    create(:item, unit_price: 10, name: 'Burger')
                    create(:item, unit_price: 25, name: 'Steak')
                    get '/api/v1/items/find?max_price=15'
                    response_info = JSON.parse(response.body, symbolize_names: true)
                    expect(response_info[:data][:attributes][:unit_price]).to be < 15
                end
                it 'will return one item that matches both max and min prices' do 
                    create(:item, unit_price: 8, name: 'Burrito')
                    create(:item, unit_price: 10, name: 'Burger')
                    create(:item, unit_price: 25, name: 'Steak')
                    get '/api/v1/items/find?min_price=15&max_price=30'
                    response_info = JSON.parse(response.body, symbolize_names: true)
                    expect(response_info[:data][:attributes][:unit_price]).to be > 15
                    expect(response_info[:data][:attributes][:unit_price]).to be < 30
                end
                it 'will return an error if not found' do 
                    get '/api/v1/items/find?min_price=15&max_price=30'
                    response_info = JSON.parse(response.body, symbolize_names: true)
                    expect(response_info[:error]).to eq('not found')
                end
                it 'will return an error if both name and price params are passed' do 
                    get '/api/v1/items/find?min_price=15&name=ap'
                    response_info = JSON.parse(response.body, symbolize_names: true)
                    expect(response_info[:error]).to eq('bad request')
                end
                it 'will return an error if both numeric values are negative and thus invalid' do 
                    get '/api/v1/items/find?min_price=-5&max_price=-3'
                    response_info = JSON.parse(response.body, symbolize_names: true)
                    expect(response_info[:error]).to eq('bad request')

                end
            end
        end
        describe '/find_all' do 
            before :each do 
                create(:item, unit_price: 40, name: 'item_1')
                create(:item, unit_price: 50, name: 'item_2')
                create(:item, unit_price: 90, name: 'item_3')
                create(:item, unit_price: 5, name: 'item_4')
            end
            describe 'name query' do 
                describe 'happy path' do 
                    it 'will return all items case insensitive that match param' do 
                        get '/api/v1/items/find_all?name=iTe'
                        response_info = JSON.parse(response.body, symbolize_names: true)
                        expect(response_info[:data].count).to eq(4)
                    end
                end
                describe 'sad path' do 
                    it 'will return an error if no items are found' do 
                        
                    end
                end
            end
            describe 'price queries' do 
                describe 'happy path' do 
                    it 'will return all of the items that match min and max' do 
                        get '/api/v1/items/find_all?min_price=30&max_price=60'
                        response_info = JSON.parse(response.body, symbolize_names: true)
                        expect(response_info[:data].first[:attributes][:name]).to eq('item_1')
                        expect(response_info[:data].second[:attributes][:name]).to eq('item_2')
                    end
                end
                describe 'sad path testing' do 
                    it 'will return an error if either param is negative' do 
                        get '/api/v1/items/find_all?min_price=-5&max_price=70'
                        response_info = JSON.parse(response.body, symbolize_names: true)
                        expect(response_info[:error]).to eq('bad request')
                    end
                    it 'will return an error if name and min values are passed as query params' do 
                        get '/api/v1/items/find_all?max_price=70&name=name1'
                        response_info = JSON.parse(response.body, symbolize_names: true)
                        expect(response_info[:error]).to eq('bad request')
                    end
                    it 'will return not found if no records match the params' do 
                        get '/api/v1/items/find_all?max_price=3'
                        response_info = JSON.parse(response.body, symbolize_names: true)
                        expect(response_info[:error]).to eq('not found')
                    end
                end
            end
        end
    end 
end