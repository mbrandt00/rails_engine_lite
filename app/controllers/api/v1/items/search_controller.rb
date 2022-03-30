class Api::V1::Items::SearchController < ApplicationController
  def show
    if params[:name].present? && (params[:min_price].present? == false && params[:max_price].present? == false)
      query = Item.find_item_name(params[:name])
      if query.nil?
        render json: { data: { error: :null } }, status: :ok
      else
        render json: ItemSerializer.new(query)
      end
    elsif params[:name].present? && (params[:min_price].present? || params[:max_price].present?)
      render json: { error: 'bad request' }, status: :bad_request
    elsif params[:min_price].present? || params[:max_price].present?
      if params[:min_price].to_i < 0 || params[:max_price].to_i < 0
        render json: { error: 'bad request' }, status: :bad_request
      elsif params[:min_price].present? && params[:max_price].present? && params[:min_price].to_i >= params[:max_price].to_i
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
      render json: {data: {error: :null}}, status: :bad_request
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
          render json: { data: { error: :null } }, status: :ok
        end
      end
    elsif params.has_key?(:name) && params[:name].empty?
      render json: { data: { error: :null } }, status: :bad_request
    elsif params.has_key?(:name) == false
      render json: { data: { error: :null } }, status: :bad_request
    end
  end
end

# module?
