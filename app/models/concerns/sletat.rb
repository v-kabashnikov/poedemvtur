require 'open-uri'

module Sletat
  # also notice the call to 'freeze'
  SERVICE_URL = "https://module.sletat.ru/Main.svc/".freeze

  def get_data query    
    uri_schema = URI.escape(SERVICE_URL + query)
    json = open(uri_schema).read
    res = JSON.parse(json)
  end

  def get_res_data query
    data = get_data query
    data["#{query}Result"]["Data"]
  end
 
end
