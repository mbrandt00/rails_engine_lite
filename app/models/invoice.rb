class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :invoice_items, dependent: :destroy
  has_many :transactions
  enum status: { inprogress: 0, completed: 1, cancelled: 2 }

  after_update :sum_cost

  # update status if all invoice items are shipped? 

  def sum_cost
    invoice_items.sum(&:calculate_units_cost)
  end
end