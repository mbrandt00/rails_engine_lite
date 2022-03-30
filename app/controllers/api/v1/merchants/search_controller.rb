class Api::V1::Merchants::SearchController < ApplicationController
  def show
    if params[:name].present?
      query = Merchant.find_merchant(params[:name])
      if query.nil?
        render json: {data: {error: :null}}, status: :ok
      else 
        render json: MerchantSerializer.new(query)
      end
    else 
      render json: {data: {error: :null}}, status: :bad_request
    end
  end

  def index
    if params[:name].present?
      render json: MerchantSerializer.new(Merchant.find_all_merchants(params[:name]))
    elsif(params.has_key?(:name) && params[:name].empty?)
      render json: {data: {error: :null}}, status: :bad_request
    elsif params.has_key?(:name) ==  false 
      render json: {data: {error: :null}}, status: :bad_request
    end
  end
end