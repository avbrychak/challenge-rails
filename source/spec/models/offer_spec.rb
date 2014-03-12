require 'spec_helper'

describe Offer do
  context " should crawl the API and create offers in the database" do
    it "#get_xml should get xml document from API" do
      response = Offer.get_xml
      Nokogiri::XML(response.body).class.should == Nokogiri::XML::Document
    end
    it "#crawl should fill database if empty" do
      Offer.count.should == 0
      Offer.crawl
      Offer.count.should_not == 0
    end
  end
  context "should be able to crawl the API multiple times and not create duplicate offers" do
    it "#crawl don't make duplicates" do
      Offer.crawl
      offers = Offer.all
      Offer.crawl
      offers.should == Offer.all
    end
  end
end
