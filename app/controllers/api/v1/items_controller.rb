class Api::V1::ItemsController < ApplicationController
    # before_action :is_customer?
    before_action :set_item, only: %i[ show update destroy ]
    def index
        render json: ItemSerializer.new(Item.all)
    end

    def show
        # two different views for merchant and customer. 
        # Customer can add item + quantity to invoice 
        # Merchant can delete/update item
        if current_user.type_of_user == 'customer' 
            render json: ItemSerializer.new(@item)
        elsif current_user.type_of_user == 'merchant' 
           binding.pry # Item changes here 
        end
    end

    def create
        item = Item.create(item_params)
        if item.save
            render json: ItemSerializer.new(item)
        else 
            render json: { error: 'bad request' }, status: :bad_request
        end
    end
    #here do i went {like #16 or more information}
    def update
        if @item.update(item_params)
            render json: ItemSerializer.new(@item)
        else 
            render json: {error: @item.errors}, status: :bad_request
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
    # private 
    # def is_customer?
    #     render json: {error: 'Access denied'}, status: :forbidden if current_user.try(:customer).nil?
    # end
  
end