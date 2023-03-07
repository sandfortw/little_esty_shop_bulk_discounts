# frozen_string_literal: true

class BulkDiscount < ApplicationRecord
  belongs_to :merchant
  validates_presence_of :percent_discounted
  validates_presence_of :quantity_threshold
  validates :quantity_threshold, numericality: { only_integer: true, greater_than: 0 }
  validates :percent_discounted, numericality: { only_integer: true, greater_than: 0, less_than: 101 }

  def obsolete?(merchant)
    return false if merchant.bulk_discounts.empty?
    merchant.bulk_discounts
            .where('bulk_discounts.percent_discounted < ? or bulk_discounts.quantity_threshold > ?', percent_discounted, quantity_threshold)
            .empty?
  end
end
