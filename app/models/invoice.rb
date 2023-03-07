# frozen_string_literal: true

class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  has_many :bulk_discounts, through: :merchants

  enum status: [:cancelled, 'in progress', :completed]

  def total_revenue
    invoice_items.sum('unit_price * quantity')
  end

  def discount_total_revenue
    max_discount_table =  InvoiceItem
                                    .joins(:item)
                                    .joins('LEFT JOIN bulk_discounts ON items.merchant_id = bulk_discounts.merchant_id AND invoice_items.quantity >= bulk_discounts.quantity_threshold')
                                    .where(invoice_id: id)
                                    .select('invoice_items.*, MAX(bulk_discounts.percent_discounted) AS max_discount')
                                    .group(:id)
    table_sum(max_discount_table)
  end

  def merchant_total_revenue(merchant)
    invoice_items.joins(:item).where('items.merchant_id = ?', merchant.id).sum('invoice_items.unit_price * quantity')
  end

  def merchant_total_revenue_discounted(merchant)
    max_discount_table =  InvoiceItem
                                    .joins("INNER JOIN items ON invoice_items.item_id = items.id AND items.merchant_id = #{merchant.id}")
                                    .joins('LEFT JOIN bulk_discounts ON items.merchant_id = bulk_discounts.merchant_id AND invoice_items.quantity >= bulk_discounts.quantity_threshold')
                                    .where(invoice_id: id)
                                    .select('invoice_items.*, MAX(bulk_discounts.percent_discounted) AS max_discount')
                                    .group(:id)

                                    
    table_sum(max_discount_table)
  end

private
  def table_sum(max_discount_table)
    InvoiceItem.from(max_discount_table, :max_discount_table).sum("CASE WHEN max_discount_table.max_discount IS NOT NULL THEN (((100 - max_discount_table.max_discount) / 100.0) * max_discount_table.unit_price * max_discount_table.quantity) ELSE max_discount_table.unit_price * max_discount_table.quantity END")
  end
end
