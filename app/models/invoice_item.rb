class InvoiceItem < ApplicationRecord
    belongs_to :invoice
    belongs_to :item
    enum status: { pending: 0, packaged: 1, shipped: 2 }
    after_create :set_price
  def self.total_revenue(start_date, end_date)
    joins(invoice: :transactions).
    where('transactions.updated_at > ?', start_date).
    where('transactions.updated_at < ?', end_date).
    group('invoice_items.id').
    select('SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue')
  end

  private 
  def set_price
    self.unit_price = self.item.unit_price
    self.save
  end

end
