class Api::V1::Items::SearchController < ApplicationController
  def show
    if params[:name].present? && (params[:min_price].present? == false && params[:max_price].present? == false)
      render json: ItemSerializer.new(Item.find_item_name(params[:name]))
    elsif params[:name].present? && (params[:min_price].present? || params[:max_price].present?)
      render json: { error: 'bad request' }, status: :bad_request
    elsif params[:min_price].present? || params[:max_price].present?
      if params[:min_price].to_i < 0 || params[:max_price].to_i < 0 
        render json: { error: 'bad request' }, status: :bad_request
      else # Either present at least one greater than 0 
        query = Item.find_matching_item(params[:min_price], params[:max_price])
        if query.any?
          render json: ItemSerializer.new(Item.find(query.first.id))
        else 
          render json: { error: 'not found' }, status: :not_found
        end
      end
    end
  end

  def index
    if params[:name].present? && (params[:min_price].present? == false && params[:max_price].present? == false)
      render json: ItemSerializer.new(Item.find_all_items_name(params[:name]))
    elsif params[:name].present? && (params[:min_price].present? || params[:max_price].present?)
      render json: { error: 'bad request' }, status: :bad_request
    elsif params[:min_price].present? || params[:max_price].present?
      if params[:min_price].to_i < 0 || params[:max_price].to_i < 0 
        render json: { error: 'bad request' }, status: :bad_request
      else # Either present at least one greater than 0 
        query = Item.find_matching_item(params[:min_price], params[:max_price])
        if query.any?
          render json: ItemSerializer.new(query)
        else 
          render json: { error: 'not found' }, status: :not_found
        end
      end
    end
  end
end

# module? 