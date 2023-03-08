# frozen_string_literal: true

class BulkDiscount < ApplicationRecord
  belongs_to :merchant
  validates_presence_of :percent_discounted
  validates_presence_of :quantity_threshold
  validates :quantity_threshold, numericality: { only_integer: true, greater_than: 0 }
  validates :percent_discounted, numericality: { only_integer: true, greater_than: 0, less_than: 101 }
  validates_with DiscountValidator, if: :new_record?

  def obsolete?
    if merchant # This line gets around the shoulda matchers bug
      unless id.nil?
        return false if merchant.bulk_discounts.where('bulk_discounts.id != ?', id).empty?
      end
      return false if merchant.bulk_discounts.empty?
      return merchant.bulk_discounts
                     .where('bulk_discounts.percent_discounted < ? or bulk_discounts.quantity_threshold > ?', percent_discounted, quantity_threshold)
                     .empty?
    end
    false
  end

end
