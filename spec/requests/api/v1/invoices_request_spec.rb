require 'rails_helper'

RSpec.describe 'Invoices Controller' do 
    describe 'creating an invoice' do 
        before :each do 
            @user = create(:user, type_of_user: 0)
            post '/api/v1/sessions', params: {email: @user.email, password: @user.password}
        end
        it 'will initially have no invoices' do 
            get '/api/v1/invoices'
            response_info = JSON.parse(response.body, symbolize_names: true)
            expect(response_info[:data]).to eq([])
            expect(response_info[:status]).to eq("no_content")
        end
        it 'can create an invoice with invoice items' do 
            item = create(:item)
            post '/api/v1/invoices', params: {item: item.id, quantity: 5 }
            response_info = JSON.parse(response.body, symbolize_names: true)
            expect(response_info[:data][:attributes][:item_info].length).to eq(1)
            expect(response_info[:data][:attributes][:item_info].first).to have_key(:merchant)
            expect(response_info[:data][:attributes][:item_info].first).to have_key(:item)
            expect(response_info[:data][:attributes][:item_info].first).to have_key(:quantity)
            expect(response_info.first)
            
        end
        it 'will add another invoice item to a pending invoice' do 
            item = create(:item)
            post '/api/v1/invoices', params: {item: item.id, quantity: 5 }
            item_2 = create(:item)
            post '/api/v1/invoices', params: {item: item_2.id, quantity: 3 }
            response_info = JSON.parse(response.body, symbolize_names: true)
            expect(response_info[:data][:attributes][:item_info].length).to eq(2)
            expect(response_info[:data][:attributes][:item_info].first[:item][:id]).to eq(item.id)
            expect(response_info[:data][:attributes][:item_info].second[:item][:id]).to eq(item_2.id)
        end
        it 'will create a new invoice if an invoice if there is no pending invoice' do 
            item = create(:item)
            post '/api/v1/invoices', params: {item: item.id, quantity: 5 }
            @user.customer.invoices.first.completed!
            item_2 = create(:item)
            post '/api/v1/invoices', params: {item: item.id, quantity: 5 }
            expect(@user.customer.invoices.length).to eq(2)
        end
    end
    describe 'showing all invoices' do 
        before :each do 
            @user = create(:user, type_of_user: 0)
            post '/api/v1/sessions', params: {email: @user.email, password: @user.password}
        end
        it 'will show all invoices' do 
            item_1 = create(:item)
            post '/api/v1/invoices', params: {item: item_1.id, quantity: 5 }
            item_2 = create(:item)
            post '/api/v1/invoices', params: {item: item_2.id, quantity: 4 }      
            @user.customer.invoices.first.completed!
            item_3 = create(:item)
            post '/api/v1/invoices', params: {item: item_3.id, quantity: 6 }
            get '/api/v1/invoices'
            response_info = JSON.parse(response.body, symbolize_names: true)
            expect(response_info[:data].count).to eq(2)
            expect(response_info[:data].first[:attributes]).to include(:status, :total_cost, :invoice_items_status, :invoice_items)
            expect(response_info[:data].first[:attributes][:invoice_items_status]).to include(:pending, :packaged, :shipped)
        end
    end
    describe 'invoice show' do 
        before :each do 
            @user = create(:user, type_of_user: 0)
            post '/api/v1/sessions', params: {email: @user.email, password: @user.password}
        end
        it 'will show one invoice' do 
            item_1 = create(:item)
            post '/api/v1/invoices', params: {item: item_1.id, quantity: 5 }
            item_2 = create(:item)
            post '/api/v1/invoices', params: {item: item_2.id, quantity: 4 }
            get "/api/v1/invoices/#{@user.customer.invoices.first.id}"
            response_info = JSON.parse(response.body, symbolize_names: true)
            binding.pry
        end
        
    end
end