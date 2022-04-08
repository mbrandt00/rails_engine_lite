class AddTables < ActiveRecord::Migration[5.2]
  def change
    ActiveRecord::Schema.define(version: 20_220_222_011_514) do
      # These are extensions that must be enabled in order to support this database
      enable_extension 'plpgsql'

      create_table 'customers', force: :cascade do |t|
        t.string 'first_name'
        t.string 'last_name'
        t.datetime 'created_at'
        t.datetime 'updated_at'
      end

      create_table 'invoice_items', force: :cascade do |t|
        t.integer 'quantity'
        t.integer 'unit_price'
        t.integer 'status', default: 0
        t.datetime 'created_at'
        t.datetime 'updated_at'
        t.bigint 'item_id'
        t.bigint 'invoice_id'
        t.index ['invoice_id'], name: 'index_invoice_items_on_invoice_id'
        t.index ['item_id'], name: 'index_invoice_items_on_item_id'
      end

      create_table 'invoices', force: :cascade do |t|
        t.integer 'status', default: 0
        t.datetime 'created_at'
        t.datetime 'updated_at'
        t.bigint 'customer_id'
        t.index ['customer_id'], name: 'index_invoices_on_customer_id'
      end

      create_table 'items', force: :cascade do |t|
        t.string 'name'
        t.string 'description'
        t.integer 'unit_price'
        t.datetime 'created_at'
        t.datetime 'updated_at'
        t.bigint 'merchant_id'
        t.index ['merchant_id'], name: 'index_items_on_merchant_id'
      end

      create_table 'merchants', force: :cascade do |t|
        t.string 'name'
        t.datetime 'created_at'
        t.datetime 'updated_at'
        t.integer 'status', default: 0
      end

      create_table 'transactions', force: :cascade do |t|
        t.bigint 'credit_card_number'
        t.date 'credit_card_expiration_date'
        t.integer 'result'
        t.datetime 'created_at'
        t.datetime 'updated_at'
        t.bigint 'invoice_id'
        t.index ['invoice_id'], name: 'index_transactions_on_invoice_id'
      end

      add_foreign_key 'invoice_items', 'invoices'
      add_foreign_key 'invoice_items', 'items'
      add_foreign_key 'invoices', 'customers'
      add_foreign_key 'items', 'merchants'
      add_foreign_key 'transactions', 'invoices'
    end
  end
end
