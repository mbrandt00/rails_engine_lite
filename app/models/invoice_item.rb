class InvoiceItem < ApplicationRecord
    belongs_to :invoice
    belongs_to :item


  def self.total_revenue(start_date, end_date)
    joins(invoice: :transactions).
    where('transactions.updated_at > ?', start_date).
    where('transactions.updated_at < ?', end_date).
    group('invoice_items.id').
    select('SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue')
  end

end
