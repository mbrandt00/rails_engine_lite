class Api::V1::Revenue::MerchantsController < ApplicationController
    def index
        if params[:quantity].present? && params[:quantity].to_i > 0
            render json: MerchantNameRevenueSerializer.new(Merchant.top_merchants(params[:quantity]))
        else 
            render json: {error: 'bad request'}, status: :bad_request
        end
    end

    def total_revenue 
       binding.pry 
       
    end
end