class Merchant < ActiveRecord::Base
  has_many :offers, foreign_key: :merchant_id, primary_key: :merchant_id
end
