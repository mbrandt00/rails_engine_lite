class Api::V1::ItemsController < ApplicationController
    before_action :set_item, only: %i[ show update destroy ]
    def index
        render json: ItemSerializer.new(Item.all)
    end

    def show
        render json: ItemSerializer.new(@item)
    end

    def create
        item = Item.create(item_params)
        if item.save
            render json: ItemSerializer.new(item)
        else 
            render json: { error: 'bad request' }, status: :bad_request
        end
    end

    def update
        if @item.update(item_params)
            render json: ItemSerializer.new(@item)
        else 
            render json: @item.errors, status: :bad_request
        end
    end

    def destroy
        @item.destroy
        head :no_content
    end

    private

    def item_params
        params.permit(:name, :description, :unit_price, :merchant_id)
    end

    def set_item
        @item = Item.find(params[:id])
        rescue ActiveRecord::RecordNotFound
            render json: { error: 'not found' }, status: :not_found
    end
  
end