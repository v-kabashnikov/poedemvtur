class CountriesController < ApplicationController
  layout 'static'

  def index
	  @countries = Country.all
	  @categories = CountryCategory.all
	end

  def show
    @country = Country.find(params[:id])
    @hotels = @country.hotels
    @popular_resorts = @hotels.
      select('resorts.name, hotels.hotel_rate').
      where('hotels.hotel_rate IS NOT NULL').
      order('hotels.hotel_rate DESC').
      group('resorts.name, hotels.hotel_rate')[0..19]

    @resorts = Resort.
      where(country_id: @country.id).
      where(seasonality: true).
      paginate(page: 1, per_page: 5)

    @resorts_without_season = @country.resorts.where(seasonality: [nil, false])

    @min_prices = {}

    @hotels.
      joins(:search_results).
      select('hotels.resort_id, MIN(search_results.min_price) price').
      group('hotels.resort_id').
      each do |res|
        @min_prices[res['id'].to_i] = res['price'].to_f
      end

    render layout: false
  end

  def resort_items
    @country = Country.find(params[:id])
    @resorts = Resort.
      where(country_id: @country.id).
      where(seasonality: true).
      paginate(page: params[:page], per_page: 5)

    @min_prices = {}

    @hotels = @country.hotels

    @hotels.
      joins(:search_results).
      select('hotels.resort_id, MIN(search_results.min_price) price').
      group('hotels.resort_id').
      each do |res|
        @min_prices[res['id'].to_i] = res['price'].to_f
      end

    render partial: 'resort_items', layout: false
  end

  def feedback_phone
    UserMailer.feedback_phone('office_m@poedemvtour.ru', params: params).deliver

    render nothing: true
  end

  def show_region
  	@categories = CountryCategory.all
    @category = CountryCategory.find(params[:id])
  	@countries = CountryCategory.find(params[:id]).countries
  end
end
