class Api::V1::InvoicesController < ApplicationController
    before_action :is_customer?
    def index 
        
        if current_user.customer.invoices.empty? 
            render json: {data: [], status: :no_content}
        else 
            render json: InvoiceIndexSerializer.new(current_user.customer.invoices)
        end
    end
    
    def create 
        # empty or no inprogress active invoices? 
        if current_user.customer.invoices.empty? || current_user.customer.invoices.all? {|invoice| invoice.cancelled? || invoice.completed?}
            invoice = current_user.customer.invoices.new(status: 0)
            InvoiceItem.create(invoice: invoice, item_id: params[:item], quantity: params[:quantity], status:0 )
        else 
            invoice = current_user.customer.invoices.where(status: 0).first
            InvoiceItem.create(invoice: invoice, item_id: params[:item], quantity: params[:quantity], status:0 )
        end
        render json: InvoiceSerializer.new(invoice)
    end
    
    def show 
        render json: InvoiceSerializer.new(Invoice.find(params[:id]))
    end
    private 
    def is_customer?
        current_user.try(:customer)
    end
end