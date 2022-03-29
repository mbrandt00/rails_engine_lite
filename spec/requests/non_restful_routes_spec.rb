require 'rails_helper'

RSpec.describe 'non-restful' do 
    describe '/find'
        it 'will find the first merchant object alphabetically that matches a search term ' do 

            get '/api/v1/merchants/find'
            response_info = JSON.parse(response.body, symbolize_names: true)
            binding.pry
        end
end