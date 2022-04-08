class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :invoice_items, dependent: :destroy
  has_many :transactions
  enum status: { inprogress: 0, completed: 1, cancelled: 2 }
end