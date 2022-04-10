class InvoiceIndexSerializer
  include JSONAPI::Serializer
  attributes :status
  attributes :total_cost do |object| 
    object.sum_cost
  end
  attributes :invoice_items do |object| 
    string = object.invoice_items.map {|ii| ii.item.name}.join(', ')
    count = object.invoice_items.count
    [string, count]
  end
  attributes :invoice_items_status do |object| 
    {
      pending: object.invoice_items.where(status: 'pending').count, 
      packaged: object.invoice_items.where(status: 'packaged').count, 
      shipped: object.invoice_items.where(status: 'shipped').count, 
    }
  end
end
