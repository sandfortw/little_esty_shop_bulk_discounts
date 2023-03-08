# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BulkDiscount, type: :model do
  
  describe 'validations' do
    it { should validate_presence_of :percent_discounted }
    it { should validate_presence_of :quantity_threshold }
    it { should validate_numericality_of(:percent_discounted).only_integer.is_greater_than(0).is_less_than(101) }
    it { should validate_numericality_of(:quantity_threshold).only_integer.is_greater_than(0) }
  end
  describe 'relationships' do
    it { should belong_to :merchant }
  end

  describe '#obsolete?' do
    before do
      @merchant = create(:merchant)
      @bulk_discount1 = BulkDiscount.create!(percent_discounted: 20, quantity_threshold: 10, merchant_id: @merchant.id)
      @bulk_discount2 = BulkDiscount.new(percent_discounted: 15, quantity_threshold: 10, merchant_id: @merchant.id)
      @bulk_discount3 = BulkDiscount.new(percent_discounted: 15, quantity_threshold: 15, merchant_id: @merchant.id)
      @bulk_discount4 = BulkDiscount.new(percent_discounted: 15, quantity_threshold: 5, merchant_id: @merchant.id)
      @bulk_discount5 = BulkDiscount.new(percent_discounted: 25, quantity_threshold: 5, merchant_id: @merchant.id)
      @bulk_discount6 = BulkDiscount.new(percent_discounted: 25, quantity_threshold: 10, merchant_id: @merchant.id)
      @bulk_discount7 = BulkDiscount.new(percent_discounted: 25, quantity_threshold: 15, merchant_id: @merchant.id)
    end
    describe 'tells you whether a new bulk discount is made obsolete by a previously existing bulk discount' do
      it 'the discount is less than an existing discount at same threshold' do
        expect(@bulk_discount2.obsolete?).to be(true)
      end

      it 'the discount is less than an existing discount at larger threshold' do
        expect(@bulk_discount3.obsolete?).to be(true)
      end
      it 'the discount is less than an existing discount at smaller threshold' do
        expect(@bulk_discount4.obsolete?).to be(false)
      end
      it 'discount is greater than an existing discount regardless of threshold' do
        expect(@bulk_discount5.obsolete?).to be(false)
        expect(@bulk_discount6.obsolete?).to be(false)
        expect(@bulk_discount7.obsolete?).to be(false)
      end

      it 'if there are no bulk discounts for a merchant, the discount cannot be obsolete' do
        expect(@merchant.bulk_discounts).to_not be_empty
        @bulk_discount1.destroy
        expect(@merchant.bulk_discounts).to be_empty
        expect(@bulk_discount2.obsolete?).to be(false)
      end
    end
  end
end
