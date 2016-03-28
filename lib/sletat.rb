require 'open-uri'
require 'rest-client'

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
    url = SERVICE_URL + method + '?' + auth_str + '&' + params.to_query
    uri_schema = URI(url)
    puts uri_schema
    RestClient.proxy = ENV["PROXIMO_URL"] if ENV["PROXIMO_URL"]
    res = RestClient.get(url)

    # json = open(uri_schema).read
    json = JSON.parse(res.body)
    puts url
    json
  end

  def get_res_data method, auth = false, params = nil
    data = get_data method, auth, params
    # puts data
    data["#{method}Result"]["Data"]
  end

  def start_search params
    binding.pry
    # puts "==== 1111 ADULTS #{params[:s_adults]}"

    case params[:place_type]
      when 'hotel'
        hotel = Hotel.find(params[:place_id])
        hotels = hotel.sletat_id
        countryId = hotel.resort.country.sletat_id
      when 'resort'
        resort  = Resort.find(params[:place_id])
        cities = resort.sletat_id
        countryId = resort.country.sletat_id
      when 'country'
        countryId = Country.find(params[:place_id]).sletat_id
    end
    if params[:date_min].empty?
      s_departFrom = DateTime.now.to_date
    else
      s_departFrom = Date.parse(params[:date_min])
    end
    s_departTo = params[:date_max].empty? ? s_departFrom :  Date.parse(params[:date_max])
    s_nightsMin = params[:nights_min]
    s_nightsMax = params[:nights_max]
    priceMax = params['roundtour-price'].split(';')[1]
    priceMin = params['roundtour-price'].split(';')[0]

   # s_nights = params["s_nights"].split('-')
   # s_departFrom = Date.parse(params['s_departFrom'])
   # s_departTo = s_departFrom + 45.days
    meals = params[:meals].to_i > 0 ? params[:meals] : nil
   # hotel = Hotel.find(params[:hotel_id]) if params[:hotel_id]
   # hotels = hotel.sletat_id if hotel
   # countryId = params[:countryId] || (hotel.resort.country.sletat_id if hotel)
    url_params = { cityFromId: params[:city_id], countryId: countryId,
                   s_adults: params[:adult], s_kids: params[:children], s_nightsMin: s_nightsMin, s_nightsMax: s_nightsMax,
                   s_priceMin: priceMin, s_priceMax: priceMax, s_departFrom: s_departFrom.strftime("%d/%m/%Y"),
                   s_departTo: s_departTo.strftime("%d/%m/%Y"), s_hotelIsNotInStop: true, s_hasTickets: true,
                   includeDescriptions: 1, updateResult: 0, hotels: hotels, meals: meals}

    data = get_res_data 'GetTours', true, url_params
    requestId = data["requestId"]

    url_params[:updateResult] = 1
    url_params[:requestId] = requestId
    url_params[:pageSize] = 3000
    nights_string = "#{s_nightsMin}-#{s_nightsMax}"
    ls = LoadStatus.create(
      request_id: requestId,
      status: 0,
      country: Country.find_by_sletat_id(countryId),
      depart_city: DepartCity.find_by_sletat_id(params[:city_id]),
      depart_from: s_departFrom,
      nights: nights_string,
      adults: params[:adult].to_i,
      kids: params[:children].to_i
    )

    puts "start_search #{ls.id}"
    TourLoader.perform_async(requestId, url_params)
    ls
  end

  private
  def auth_str
    "login=#{LOGIN}&password=#{PASS}"
  end

end
