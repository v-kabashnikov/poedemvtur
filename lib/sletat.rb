require 'open-uri'

module Sletat
  # also notice the call to 'freeze'
  SERVICE_URL = "https://module.sletat.ru/Main.svc/".freeze
  LOGIN = "pr@corona.travel"
  PASS = "1234567"

  SOAP_HEADER = {
    "AuthInfo" => {
      "@xmlns" => "urn:SletatRu:DataTypes:AuthData:v1",
      "Login"  => LOGIN,
      "Password"  => PASS
    }
  }

  def soap_client
    Savon.client(wsdl: "http://module.sletat.ru/XmlGate.svc?singleWSDL", soap_header: SOAP_HEADER)
  end

  def get_data method, auth, params
    uri_schema = URI(SERVICE_URL + method + '?' + auth_str + '&' + params.to_query)
    # puts uri_schema
    # binding.pry
    json = open(uri_schema).read
    res = JSON.parse(json)
    puts '2'*100, res
    res
  end

  def get_res_data method, auth = false, params = nil
    data = get_data method, auth, params
    data["#{method}Result"]["Data"]
  end

  def start_search params
    s_nights = params["s_nights"].split('-')
    s_departFrom = Date.parse(params['s_departFrom'])
    s_departTo = s_departFrom + 45.days
    meals = params[:meals].to_i > 0 ? params[:meals] : nil
    hotel = Hotel.find(params[:hotel_id]) if params[:hotel_id]
    hotels = hotel.sletat_id if hotel
    countryId = params[:countryId] || (hotel.resort.country.sletat_id if hotel)
    url_params = { cityFromId: params[:cityFromId], countryId: countryId,
                   s_adults: params[:s_adults], s_kids: params[:s_kids], s_nightsMin: s_nights[0], s_nightsMax: s_nights[1],
                   s_priceMin: params[:s_priceMin], s_priceMax: params[:s_priceMax], s_departFrom: s_departFrom.strftime("%d/%m/%Y"),
                   s_departTo: s_departTo.strftime("%d/%m/%Y"), s_hotelIsNotInStop: true, s_hasTickets: true,
                   includeDescriptions: 1, updateResult: 0, hotels: hotels, meals: meals}

    data = get_res_data 'GetTours', true, url_params
    requestId = data["requestId"]

    url_params[:updateResult] = 1
    url_params[:requestId] = requestId
    url_params[:pageSize] = 3000
    
    puts 'start_search'
    TourLoader.perform_async(requestId, url_params)
    requestId
  end

  private
  def auth_str
    "login=#{LOGIN}&password=#{PASS}"
  end

end
