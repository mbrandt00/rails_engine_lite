class Api::V1::ItemsController < ApplicationController
    before_action :set_item, only: %i[ show update destroy merchant ]
    def index 
        render json: Item.all
    end

    def show 
        render json: @item
    end
    def create 
        item = Item.create(item_params)
        if item.save
            render json: item
        else 
            render json: { message: "Validation failed", errors: item.errors}
        end
    end

    def update 
        if @item.update(item_params)
            render json: @item
        else
            render json: @item.errors, status: :unprocessable_entity
        end
    end
    def destroy 
        @item.destroy
    end

    def merchant 
        render json: @item.merchant
    end

    private 

    def item_params
        params.permit(:name, :description, :unit_price, :merchant_id)
    end
    def set_item
      @item = Item.find(params[:id])
    end
end