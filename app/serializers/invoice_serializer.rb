class InvoiceSerializer
  include JSONAPI::Serializer
  attributes :status
  attributes :item_info do |object| 
    object.invoice_items.map do |ii|
      {
        item_status: ii.status,
        merchant: Merchant.find(ii.item.merchant_id), 
        item: Item.find(ii.item_id), 
        quantity: ii.quantity
      }
    end
  end
end