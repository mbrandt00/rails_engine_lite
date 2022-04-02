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
            it 'will return an error if no params are passed' do 
                get '/api/v1/merchants/find'
                response_info = JSON.parse(response.body, symbolize_names: true)
                expect(response_info[:data][:error]).to eq("null")
            end
            it 'will find the first merchant object alphabetically that matches a search term' do 
                create(:merchant, name: 'apple')
                create(:merchant, name: 'aaron')
                get '/api/v1/merchants/find?name=Aaa'
                response_info = JSON.parse(response.body, symbolize_names: true)
                expect(response_info[:data][:error]).to eq("null")
            end
        end
        describe '/find_all' do 
            it 'will find all merchant objects that matches a search term ' do 
                create(:merchant, name: 'apple')
                create(:merchant, name: 'aaron')
                create(:merchant, name: 'bill')
                get '/api/v1/merchants/find_all?name=A'
                response_info = JSON.parse(response.body, symbolize_names: true)
                expect(response_info[:data].count).to eq(2)
                expect(response_info[:data][0][:attributes][:name]).to eq('aaron')
                expect(response_info[:data][1][:attributes][:name]).to eq('apple')
            end
            it 'will return an error if no name param is passed' do 
                get '/api/v1/merchants/find_all?name='
                response_info = JSON.parse(response.body, symbolize_names: true)
                expect(response_info[:data][:error]).to eq("null")
            end
            it 'will return an error if no params are passed' do 
                get '/api/v1/merchants/find_all'
                response_info = JSON.parse(response.body, symbolize_names: true)
                expect(response_info[:error]).to eq("null")
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
                it 'will return null if no items match' do 
                    get '/api/v1/items/find?name=A'
                    response_info = JSON.parse(response.body, symbolize_names: true)
                    expect(response_info[:data][:error]).to eq("null")
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
                    expect(response_info[:data][:error]).to eq('null')
                end
                it 'will return an error if both name and price params are passed' do 
                    get '/api/v1/items/find?min_price=15&name=ap'
                    response_info = JSON.parse(response.body, symbolize_names: true)
                    expect(response_info[:error]).to eq('bad request')
                end
                it 'will return a bad request if the min value is greater than max' do 
                    get '/api/v1/items/find?max_price=5&min_price=100'
                    response_info = JSON.parse(response.body, symbolize_names: true)
                    expect(response_info[:error]).to eq('bad request')
                end
                it 'will return an error if no params are passed' do 
                    get '/api/v1/items/find'
                    response_info = JSON.parse(response.body, symbolize_names: true)
                    expect(response_info[:data][:error]).to eq("null")
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
                create(:item, unit_price: 5, name: 'item_4')
                create(:item, unit_price: 5, name: 'item_3')
                create(:item, unit_price: 5, name: 'item_2')
            end
            describe 'name query' do 
                describe 'happy path' do 
                    it 'will return all items case insensitive that match param' do 
                        get '/api/v1/items/find_all?name=iTe'
                        response_info = JSON.parse(response.body, symbolize_names: true)
                        expect(response_info[:data].count).to eq(3)
                    end
                end
                describe 'sad path' do 
                    it 'will return an empty array if no items are found' do 
                        create(:item, unit_price: 40, name: 'item_1')
                        create(:item, unit_price: 50, name: 'item_2')
                        create(:item, unit_price: 90, name: 'item_3')
                        create(:item, unit_price: 90, name: 'nonsense')
                        get '/api/v1/items/find_all?name=iTefds'
                        response_info = JSON.parse(response.body, symbolize_names: true)
                        expect(response_info[:data]).to eq([])          
                    end
                    it 'will return an error if no argument is passed with name' do 
                        create(:item, unit_price: 40, name: 'item_1')
                        create(:item, unit_price: 50, name: 'item_2')
                        create(:item, unit_price: 90, name: 'item_3')
                        create(:item, unit_price: 90, name: 'nonsense')
                        get '/api/v1/items/find_all?name='
                        response_info = JSON.parse(response.body, symbolize_names: true)
                        expect(response_info[:data][:error]).to eq('null')          
                    end
                    it 'will return an error if no params are passed' do 
                        get '/api/v1/items/find_all?'
                        response_info = JSON.parse(response.body, symbolize_names: true)
                        expect(response_info[:data][:error]).to eq('null')          
                    end
                end
            end
            describe 'price queries' do 
                describe 'happy path' do 
                    it 'will return all of the items that match min and max' do 
                        create(:item, unit_price: 40)
                        create(:item, unit_price: 70)
                        create(:item, unit_price: 90)
                        create(:item, unit_price: 50)
                        get '/api/v1/items/find_all?min_price=30&max_price=60'
                        response_info = JSON.parse(response.body, symbolize_names: true)
                        expect(response_info[:data].count).to eq(2)
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
                        expect(response_info[:data][:error]).to eq('null')
                    end
                end
            end
        end
    end 
end