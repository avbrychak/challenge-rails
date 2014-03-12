class OffersController < ApplicationController
  def index
    @offers = Offer.all
  end
  def crawl
    Offer.crawl
    redirect_to offers_path
  end
end
