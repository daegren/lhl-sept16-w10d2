require 'rails_helper'
require 'support/database_cleaner'

RSpec.feature "Bicycle index", type: :feature, js: true do

  before :each do
    @bike1 = FactoryBot.create(:bicycle,
      brand: FactoryBot.create(:brand, name: 'Brand', country: 'Canada'),
      style: FactoryBot.create(:style, name: 'Fixie'),
      speeds: 1,
      colour: 'Red',
      model: 'Moustache'
    )
    @bike2 = FactoryBot.create(:bicycle,
      brand: FactoryBot.create(:brand, name: 'Hildebrand', country: 'USA'),
      style: FactoryBot.create(:style, name: 'Hybrid'),
      speeds: 10,
      colour: 'Black',
      model: 'Roadmeister'
    )
  end

  scenario "Lists all bikes" do
    visit "/bicycles"

    expect(page).to have_css('.bicycle', count: 2)
    expect(page).to have_text('Red Brand Moustache Fixie', count: 1)
    expect(page).to have_text('Black 10-speed Hildebrand Roadmeister Hybrid', count: 1)
    save_screenshot('all_bikes.png')
  end

  scenario 'Filtering by Speeds' do
    visit '/bicycles'

    fill_in 'Speeds', with: 1

    click_button 'Search!'

    expect(page).to have_css('.bicycle', count: 1)
    expect(page).to have_text('Red Brand Moustache Fixie', count: 1)
    expect(page).not_to have_text('Black 10-speed Hildebrand Roadmeister Hybrid')
  end

  scenario 'Filtering by Model' do
    visit '/bicycles'

    fill_in 'Model', with: 'Roadmeister'

    click_button 'Search!'

    expect(page).to have_css('.bicycle', count: 1)
    expect(page).to have_text('Black 10-speed Hildebrand Roadmeister Hybrid', count: 1)
    expect(page).not_to have_text('Red Brand Moustache Fixie')
  end

  scenario 'Filtering by Style' do
    visit '/bicycles'

    select 'Fixie', from: 'Style'

    # save_screenshot('filtering_by_style.png')

    click_button 'Search!'

    expect(page).to have_css('.bicycle', count: 1)
    expect(page).to have_text('Red Brand Moustache Fixie', count: 1)
    expect(page).not_to have_text('Black 10-speed Hildebrand Roadmeister Hybrid')
  end

  scenario 'Filtering by Brand' do
    visit '/bicycles'

    select 'Hildebrand', from: 'Brand'

    click_button 'Search!'

    expect(page).to have_css('.bicycle', count: 1)
    expect(page).to have_text('Black 10-speed Hildebrand Roadmeister Hybrid', count: 1)
    expect(page).not_to have_text('Red Brand Moustache Fixie')
  end

  scenario 'Filtering by All Fields' do
    visit '/bicycles'

    fill_in 'Model', with: @bike1.model
    fill_in 'Speeds', with: @bike1.speeds
    select @bike1.style.name, from: 'Style'
    select @bike1.brand.name, from: 'Brand'

    # save_screenshot('filter_all.png')

    click_button 'Search!'

    expect(page).to have_css('.bicycle', count: 1)
    expect(page).to have_text('Red Brand Moustache Fixie', count: 1)
    expect(page).not_to have_text('Black 10-speed Hildebrand Roadmeister Hybrid')
  end

end
