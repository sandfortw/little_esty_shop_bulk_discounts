# frozen_string_literal: true

require 'rails_helper'

describe 'bulk discounts index' do
  before do
    @merchant = create(:merchant)
    @bulk_discount1 = create(:bulk_discount, merchant_id: @merchant.id, percent_discounted: 10, quantity_threshold: 10)
    @bulk_discount2 = create(:bulk_discount, merchant_id: @merchant.id, percent_discounted: 20, quantity_threshold: 20)
    @bulk_discount3 = create(:bulk_discount, merchant_id: @merchant.id, percent_discounted: 30, quantity_threshold: 30)
    visit merchant_bulk_discounts_path(@merchant)
  end
  it 'has a header' do
    expect(page).to have_content("#{@merchant.name}'s Bulk Discounts")
  end

  it 'has the information for each bulk discount' do
    expect(page).to have_content('Bulk Discounts')
    expect(page).to have_content("#{@bulk_discount1.percent_discounted}% off after #{@bulk_discount1.quantity_threshold} items purchased.")
    expect(page).to have_content("#{@bulk_discount2.percent_discounted}% off after #{@bulk_discount2.quantity_threshold} items purchased.")
    expect(page).to have_content("#{@bulk_discount3.percent_discounted}% off after #{@bulk_discount3.quantity_threshold} items purchased.")
  end

  it 'each item has a link to its show page (1)' do
    within "div##{@bulk_discount1.id}" do
      click_link 'Show Page'
      expect(current_path).to eq("/merchant/#{@merchant.id}/bulk_discounts/#{@bulk_discount1.id}")
    end
  end

  it 'each item has a link to its show page (2)' do
    within "div##{@bulk_discount2.id}" do
      click_link 'Show Page'
      expect(current_path).to eq("/merchant/#{@merchant.id}/bulk_discounts/#{@bulk_discount2.id}")
    end
  end

  it 'each item has a link to its show page (3)' do
    within "div##{@bulk_discount3.id}" do
      click_link 'Show Page'
      expect(current_path).to eq("/merchant/#{@merchant.id}/bulk_discounts/#{@bulk_discount3.id}")
    end
  end

  it 'has a link to create a new bulk_discount' do
    expect(page).to have_link('Create a new Bulk Discount')
    click_link 'Create a new Bulk Discount'
    expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant))
  end

  it 'has a link to delete a bulk_discount' do
    within "div##{@bulk_discount1.id}" do
      expect(page).to have_content("#{@bulk_discount1.percent_discounted}% off after #{@bulk_discount1.quantity_threshold} items purchased.")
      click_button 'Delete'
      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant))
    end
    expect(page).to_not have_content("#{@bulk_discount1.percent_discounted}% off after #{@bulk_discount1.quantity_threshold} items purchased.")
  end

  
  it 'has the name and date of the next 3 holidays' do
    holidays = HolidaySearch.new.holidays.first(3)

    expect(page).to have_content(holidays.first.date)
    expect(page).to have_content(holidays.first.name)
    expect(page).to have_content(holidays.second.date)
    expect(page).to have_content(holidays.second.name)
    expect(page).to have_content(holidays.third.date)
    expect(page).to have_content(holidays.third.name)
  end
end
