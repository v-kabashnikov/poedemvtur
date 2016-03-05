require 'benchmark'
require 'open-uri'
require 'sletat'
class HomeController < ApplicationController
  include Sletat

  def index
  end

  def hotel
    @hotel = Hotel.find(params[:id])
    weather_url = nil
    if @hotel.latitude && @hotel.longitude
      weather_url = "http://api.openweathermap.org/data/2.5/weather?lat=#{@hotel.latitude}&lon=#{@hotel.longitude}&units=metric&lang=ru&appid=5613a0135fbd6cc6488bdd20c8aa5572"
    elsif @hotel.resort
      weather_url = URI.escape("http://api.openweathermap.org/data/2.5/weather?q=#{@hotel.resort.name},#{@hotel.resort.country.name}&units=metric&lang=ru&appid=5613a0135fbd6cc6488bdd20c8aa5572")
    end
    if weather_url
      json = open(weather_url).read
      res = JSON.parse(json)
      @weather = {
        desc: res['weather'].first['description'],
        temp: res['main']['temp'].abs.to_i,
        sign: res['main']['temp'] > 0 ? '+' : '-',
        icon: "weather/#{res['weather'].first['icon'][/[\d]+/]}.png"
      }
    end
    @request = LoadStatus.find_by(request_id: params['requestId'])
    if @request
      if @request.status == 1
        @tours = @hotel.tour_results.where(request_id: params['requestId']).limit(5)
        @total_tours = @hotel.tour_results.where(request_id: params['requestId']).count
      end
    end

    @depart_cities = DepartCity.all
    @hotel.load_facilities
    @facilities = @hotel.facilities.order(:facility_group_id).chunk(&:facility_group_id)
  end

  def check_tours
    requestId = params[:requestId]
    @hotel = Hotel.find(params[:id])
    if LoadStatus.find_by(request_id: requestId).status == 1
      @status = 'finished'
      @tours = @hotel.tour_results.where(request_id: params['requestId'].to_i).limit(5)
      @total_tours = @hotel.tour_results.where(request_id: params['requestId'].to_i).count
    else
      @status = 'loading'
      render nothing: true
    end
  end

  def load_more_tours
    per_page = 5;
    @hotel = Hotel.find(params[:id])
    total_tours = @hotel.tour_results.where(request_id: params['requestId']).count
    offset = params[:page].to_i * per_page
    @loaded = total_tours <= offset + per_page
    @tours = @hotel.tour_results.where(request_id: params['requestId']).limit(per_page).offset(offset)
  end

  def search
    # puts "==== 222 ADULTS #{params[:s_adults]}"

    # s_nights = params["s_nights"].split('-')
    # s_departFrom = Date.parse(params['s_departFrom'])
    # s_departTo = s_departFrom + 45.days
    # url_params = { cityFromId: params[:cityFromId], countryId: params[:countryId],
    #                s_adults: params[:s_adults], s_kids: params[:s_kids], s_nightsMin: s_nights[0], s_nightsMax: s_nights[1],
    #                s_priceMin: params[:s_priceMin], s_priceMax: params[:s_priceMax], s_departFrom: s_departFrom.strftime("%d/%m/%Y"),
    #                s_departTo: s_departTo.strftime("%d/%m/%Y"), s_hotelIsNotInStop: true, s_hasTickets: true,
    #                includeDescriptions: 1, updateResult: 0 }

    # data = get_res_data 'GetTours', true, url_params
    # requestId = data["requestId"]

    # url_params[:updateResult] = 1
    # url_params[:requestId] = requestId
    # url_params[:pageSize] = 3000

    # TourLoader.perform_async(requestId, url_params)
    @request = start_search(params)

    @country = @request.country.name
    # @requestId = requestId
  end

  def search_hotel
    puts "1111 #{params[:s_adults]}"
    @request = start_search(params)
    redirect_to "#{hotel_path(params[:hotel_id])}?requestId=#{@request.request_id}"
  end

  def check
    requestId = params[:requestId]
    @total = SearchResult.where(request_id: requestId).count
    if LoadStatus.find_by(request_id: requestId).status == 1
      @status = 'finished'
    else
      @status = 'loading'
    end
    @results = SearchResult.where(request_id: requestId).
      preload(hotel: [:star, resort: [:country]]).order(min_price: :asc).limit(18)
  end

  def load_more
    @results = SearchResult.where(request_id: params[:requestId]).preload(hotel: [:reviews, resort: [:country]]).order(min_price: :asc).limit(18).offset(params[:loaded])
    render 'check'
  end
end
