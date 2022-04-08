class Api::V1::InvoicesController < ApplicationController
    before_action :is_customer?
    def index 
        render json: current_user.customer.invoices
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
    private 
    def is_customer?
        current_user.try(:customer)
    end
end