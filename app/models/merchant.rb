class Merchant < ApplicationRecord
  has_many :items
  has_many :invoice_items, through: :items

  def self.find_merchant(string)
    where('name ilike ?', "%#{string}%").order(:name).first
  end

  def self.find_all_merchants(string)
    where('name ilike ?', "%#{string}%").order(:name)
  end

  def self.top_merchants(quantity)
    joins(invoice_items: {invoice: :transactions}).
    where('transactions.result = ?', 'success').
    where('invoices.status = ?', "shipped").
    group(:id).
    select('sum(invoice_items.quantity * invoice_items.unit_price) AS revenue, merchants.name AS name, merchants.id as ID').
    order(revenue: :desc).
    limit(quantity)
  end

  def self.most_items(quantity)
    joins(invoice_items: {invoice: :transactions}).
    group(:id).
    where('transactions.result = ?', 'success').
    select('sum(invoice_items.quantity) as SUM, merchants.name AS name, merchants.id AS id').
    order(sum: :desc).
    limit(quantity)
  end


end
