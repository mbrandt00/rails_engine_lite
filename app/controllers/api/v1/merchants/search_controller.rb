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
    elsif has_empty_name?(params)
      render json: {data: {error: :null}}, status: :bad_request
    elsif has_no_keys?(params)
      render json: {error: :null, data: []}, status: :bad_request
    end
  end

  def most_items
     if params[:quantity].present? && params[:quantity].to_i > 0
      render json: MerchantItemsNameSerializer.new(Merchant.most_items(params[:quantity]))
     else 
      render json: {error: 'bad request'}, status: :bad_request
    end
  end
end