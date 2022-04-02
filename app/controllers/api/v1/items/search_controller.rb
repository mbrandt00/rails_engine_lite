class Api::V1::Items::SearchController < ApplicationController
  def show
    if has_valid_name?(params) # name and nothing else
      query = Item.find_item_name(params[:name])
      if query.nil?
        render json: { data: { error: :null } }, status: :ok
      else
        render json: ItemSerializer.new(query)
      end
    elsif has_name_and_numeric?(params) # both are passed
      render json: { error: 'bad request' }, status: :bad_request
    elsif has_only_numeric?(params) # happy path for prices
      if has_negative?(params)
        render json: { error: 'bad request' }, status: :bad_request
      elsif has_min_greater_than_max?(params)
        render json: { error: 'bad request' }, status: :bad_request
      else # Either present at least one greater than 0
        query = Item.find_matching_item(params[:min_price], params[:max_price])
        if query.any?
          render json: ItemSerializer.new(Item.find(query.first.id))
        else
          render json: { data: { error: :null } }, status: :ok
        end
      end
    else
      render json: { data: { error: :null } }, status: :bad_request
    end
  end
  
  def index
    if has_valid_name?(params)
      render json: ItemSerializer.new(Item.find_all_items_name(params[:name]))
    elsif has_name_and_numeric?(params)
      render json: { error: 'bad request' }, status: :bad_request
    elsif has_only_numeric?(params)
      if has_negative?(params)
        render json: { error: 'bad request' }, status: :bad_request
      elsif has_min_greater_than_max?(params)
        render json: { error: 'bad request' }, status: :bad_request
      else # Either present at least one greater than 0
        query = Item.find_matching_item(params[:min_price], params[:max_price])
        if query.any?
          render json: ItemSerializer.new(query)
        else
          render json: { data: { error: :null } }, status: :ok
        end
      end
    elsif has_empty_name?(params)
      render json: { data: { error: :null } }, status: :bad_request
    elsif has_no_keys?(params)
      render json: { data: { error: :null } }, status: :bad_request
    end
  end
end
