class Api::V1::Merchants::SearchController < ApplicationController
  def show
    query = MerchantSerializer.new(Merchant.find_merchant(params[:name]))
    render json: query

  end

  def index
    render json: MerchantSerializer.new(Merchant.find_all_merchants(params[:name]))
  end

  def query_params
    params.permit(:name, :created_at, :updated_at)
  end
end