require 'spec_helper'

describe 'home page', :type => :feature do
  it 'It should crawl for and create offers when clicking on \
      the button and then display them. \
      Reloading the page should still show the offers.' do
    visit '/'
    click_link 'Crawl!'
    offers = Offer.all
    offers.each do |offer|
      page.should have_selector("#offer_#{offer.id}")
    end

    visit '/'
    offers.each do |offer|
      page.should have_selector("#offer_#{offer.id}")
    end
  end
end