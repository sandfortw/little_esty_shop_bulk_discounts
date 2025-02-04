require 'rails_helper'

describe 'bulk discounts edit page' do
  before do
    @merchant = create(:merchant)
    @bulk_discount = create(:bulk_discount, merchant_id: @merchant.id, percent_discounted: 40, quantity_threshold: 10)
    @bulk_discount2 = create(:bulk_discount, merchant_id: @merchant.id, percent_discounted: 20, quantity_threshold: 5)
    visit edit_merchant_bulk_discount_path(@merchant, @bulk_discount)
  end

  it 'should have a header' do
    expect(page).to have_content("Edit Bulk Discount #{@bulk_discount.id}")
  end

  it 'should start with prefilled form fields' do
    expect(page).to have_content('Percent discounted')
    expect(page).to have_field('Percent discounted', with: @bulk_discount.percent_discounted)
    expect(page).to have_content('Quantity threshold')
    expect(page).to have_field('Quantity threshold', with: @bulk_discount.quantity_threshold)
    expect(page).to have_button('Submit')
  end

  it 'when I change the form and click submit, I should change pages and see the new information' do
    fill_in('Percent discounted', with: 30)
    fill_in('Quantity threshold', with: 10)
    click_on('Submit')
    expect(current_path).to eq(merchant_bulk_discount_path(@merchant, @bulk_discount))
    expect(page).to have_content('Percentage Discount: 30')
    expect(page).to have_content('Threshold: 10')
  end

  it 'when I fil the form with invalid information, I get a flash message' do
    fill_in('Percent discounted', with: 101)
    fill_in('Quantity threshold', with: 10)
    click_on('Submit')
    expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant, @bulk_discount))
    expect(page).to have_content('Invalid input.')
  end

  it 'should not update if the discount is superseded by an existing discount, and is able to update self with worse discount' do
    fill_in('Percent discounted', with: 19)
    fill_in('Quantity threshold', with: 10)
    click_on('Submit')
    expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant, @bulk_discount))
    expect(page).to have_content('Invalid input.')
    expect(page).to have_content('You may not enter a discount that is superseded by an existing discount.')
  end

end
