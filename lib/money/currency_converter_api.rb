require "httparty"

class CurrencyConverterApi
  include HTTParty

  base_uri "https://api.apilayer.com/currency_data"
  headers "apikey" => ""
end
