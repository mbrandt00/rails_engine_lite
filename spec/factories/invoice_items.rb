FactoryBot.define do
  factory :invoice_item, class: InvoiceItem do
    quantity {rand(1..10)}
    status { rand(0..2) }
    item
    unit_price { item.unit_price }
    invoice
  end
end
