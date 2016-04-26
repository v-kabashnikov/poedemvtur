require 'benchmark'
require 'open-uri'
require 'sletat'
class HomeController < ApplicationController
  before_action :captcha_params, only: [:hotel, :feedback]
  include SimpleCaptcha::ControllerHelpers
  layout 'static', except: 'index'
  # layout 'home', only: :index
  include Sletat

  def index
    @cities = DepartCity.all
    @countries = Country.where(:hot => true)
  end

  def tour
    @hotel = Hotel.find(params[:id])
    @tour = @hotel.tour_results.find(params[:tour])
    @link = "/tournext/#{@hotel.id}?tour=#{@tour.id}"
  end

  def tournext
    @hotel = Hotel.find(params[:id])
    @tour = @hotel.tour_results.find(params[:tour])
  end

  def feedback
    if simple_captcha_valid?
      params[:family] ? people = 3 : people  = 1
      params[:date].empty? ? date = DateTime.now : date = Date.parse(params[:date]) 
      rate = ((params[:meal].to_i+params[:service].to_i)/2)
      @review = Review.create(name: params[:name], date: date, comment: params[:opinion], people_number: people ,rate: rate, hotel_id: params[:hotel_id])
      params[:review].each do |image|
        @revimg = Revimg.new
        @revimg.image = image[1]
        @revimg.review_id = @review.id
        @revimg.save
      end
      @hotel = Hotel.find(params[:hotel_id])
      UserMailer.send_signup_email("").deliver
    end
     redirect_to :back
  end


  def ajax
    if params[:p].length >= 2
    @resorts = Resort.where("lower(name) LIKE lower(?)", "%#{params[:p]}%")
    @hotels = Hotel.where("lower(name) LIKE lower(?)", "%#{params[:p]}%")
    @countries = Country.where("lower(name) LIKE lower(?)", "%#{params[:p]}%")
    end
    # render :json => @search_output
    # render nothing: true
  end

  def hotel
    @review = Review.new
    @revimg = Revimg.create(review_id: @review.id)
    @depart_city = params[:depart_city]
    @city_id = params[:city_id]
    @place_id = params[:place_id]
    @place_type = params[:place_type]
    @nights_min = params[:nights_min]
    @nights_max = params[:nights_max]
    @date_min = params[:date_min]
    @date_max = params[:date_max]
    @children = params[:children]
    @arrive_place = params[:arrive_place]
    @price = params["roundtour-price"]
    @adults = params[:adult]
    @cities = DepartCity.all
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
      @load_more = @total_tours > 5
    else
      @status = 'loading'
      render nothing: true
    end
    # ls = LoadStatus.find_by(request_id: requestId)
    # binding.pry
    # @results = ls.results.select{|tour| tour[3] == @hotel.sletat_id}
    # @status = ls.status
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
    @depart_city = params[:depart_city]
    @city_id = params[:city_id]
    @place_id = params[:place_id]
    @place_type = params[:place_type]
    @nights_min = params[:nights_min]
    @nights_max = params[:nights_max]
    @date_min = params[:date_min]
    @date_max = params[:date_max]
    @children = params[:children]
    @arrive_place = params[:arrive_place]
    @price = params["roundtour-price"]
    @adults = params[:adult]
    if @adults == "3"
      @people = "троих"
    elsif @adults == "2"
      @people = "двоих"
    elsif @adults == "4"
      @people = "четверых"
    end
    @request = start_search(params)
    @country = @request.country
    if params[:place_type] == 'hotel'
      redirect_to "/hotel/#{params[:place_id]}?requestId=#{@requestId}&depart_city=#{@depart_city}&city_id=#{@city_id}&place_id=#{@place_id}&place_type=#{@place_type}&nights_min=#{@nights_min}&nights_max=#{@nights_max}&children=#{@children}&arrive_place=#{@arrive_place}&adults=#{@adults}"
    end
    
    # @requestId = requestId
  end

  def search_hotel
    puts "1111 #{params[:s_adults]}"
    @request = start_search(params)
    redirect_to "#{hotel_path(params[:hotel_id])}?requestId=#{@request.request_id}"
  end

  #put to helper
  def is_true?(string)
    ActiveRecord::ConnectionAdapters::Column::TRUE_VALUES.include?(string)
  end

  def check
    rs = ResAmount.first.amount
    requestId = params[:requestId]
    @results = SearchResult.where(request_id: params[:requestId]).preload(hotel: [:reviews, resort: [:country]]).order(min_price: :asc).limit(rs)
    @total = SearchResult.where(request_id: requestId).count
    if LoadStatus.find_by(request_id: requestId).status == 1
      @status = 'finished'
    else
      @status = 'loading'
    end
  end

  def load_more
    @total = SearchResult.where(request_id: params[:requestId]).count
    rs = ResAmount.first.amount
    @results = SearchResult.where(request_id: params[:requestId]).preload(hotel: [:reviews, resort: [:country]]).order(min_price: :asc).limit(rs).offset(params[:loaded])
    if LoadStatus.find_by(request_id: params[:requestId]).status == 1
      @status = 'finished'
    else
      @status = 'loading'
    end
    render 'check'
  end

  def filter
      requestId = params[:requestId]
      rs = ResAmount.first.amount
      
      if LoadStatus.find_by(request_id: requestId).status == 1
        @status = 'finished'
      else
        @status = 'loading'
      end
      p = params[:filter]

      meal  = []
      meal << "BB" if is_true?(p[:eat1])
      meal << "HB" << "HB+" if is_true?(p[:eat2])
      meal << "FB" <<"FB+" if is_true?(p[:eat3])
      meal << "AL" << "UAL" if is_true?(p[:eat4])
      meal << "RO" if is_true?(params[:eat5])
      stars = []
      stars << "5*" if is_true?(p[:class1])
      stars << "4*" if is_true?(p[:class2])
      stars << "3*" if is_true?(p[:class3])
      @results = SearchResult.where(request_id: params[:requestId]).where(meal: meal, min_price: p[:priceMin]..p[:priceMax]).joins(hotel: [:star]).where('stars.name' => stars).preload(hotel: [:reviews, :star, resort: [:country]]).order(min_price: :asc) 
      @total = @results.count
      render 'check'
  end

  private
  def captcha_params
    params.permit(:col, :id, :text, :captcha, :captcha_key)
  end
end
