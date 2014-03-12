class Offer < ActiveRecord::Base
  belongs_to :merchant

  def self.crawl
    url = "https://linksearch.api.cj.com/v2/link-search"
    api_key = "00853007dc51e2bd4d3d139cbd8d387b1c3d9cae8afd4cef2a8c5add85d2808d34cf17e3303197fc22fbbd5ec4467b40c244f99035561789932878bdcf14ef7b67/1faecb4fe7d2ce415f7418e7267ef71a42b5d0f7934607e6d1389455cf3b715b70892b0ec2da8136c8bff4ab91ebcfec466caf8eacfd7d16a4ffe42e935cc0a1"
    website_id = "5742006"
    records_per_page = "20"
    Unirest.get url, 
      headers: {authorization: api_key}, 
      parameters: {"website-id" => website_id, \
        "records-per-page" => records_per_page}
  end
  def self.parse_xml response
    Nokogiri::XML(response.body).xpath("/cj-api/links/link").each do |link|
      expires_at = link.xpath("promotion-end-date").text
      Merchant.where(merchant_id: link.xpath("advertiser-id").text.to_i, \
                    name: link.xpath("advertiser-name").text).first_or_create
      Offer.where(offer_id: link.xpath("link-id").text.to_i, \
                  title: link.xpath("link-name").text, \
                  description: link.xpath("description").text, \
                  url: link.xpath("destination").text, \
                  expires_at: expires_at == "" ? nil : DateTime.parse(expires_at) 
                  ).first_or_create
    end
  end
  def self.get_new_data
    parse_xml(crawl)
  end
end
