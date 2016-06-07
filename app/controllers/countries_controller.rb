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
      order('hotels.hotel_rate DESC').
      group('resorts.name, hotels.hotel_rate')[0..19]

    @resorts = Resort.
      where(country_id: @country.id).
      joins(:hotels).
      select('resorts.id, resorts.name, hotels.id AS hotel_id').
      where(seasonality: true).
      group('resorts.id, resorts.name, hotels.id').
      paginate(page: 1, per_page: 5)

    @resorts_without_season = @country.
      resorts.
      joins(:hotels).
      select('resorts.*, hotels.id AS hotel_id').
      where(seasonality: [nil, false])

    @min_prices = {}

    @hotels.
      joins(:search_results).
      select('hotels.id, MIN(search_results.min_price) price').
      group('hotels.id').
      each do |res|
        @min_prices[res['id'].to_i] = res['price'].to_f
      end

    render layout: false
  end

  def resort_items
    @country = Country.find(params[:id])
    @resorts = Resort.
      where(country_id: @country.id).
      joins(:hotels).
      select('resorts.id, resorts.name, hotels.id AS hotel_id').
      where(seasonality: true).
      group('resorts.id, resorts.name, hotels.id').
      paginate(page: params[:page], per_page: 5)

    @min_prices = {}

    @hotels = @country.hotels

    @hotels.
      joins(:search_results).
      select('hotels.id, MIN(search_results.min_price) price').
      group('hotels.id').
      each do |res|
        @min_prices[res['id'].to_i] = res['price'].to_f
      end

    render partial: 'resort_items', layout: false
  end

  def show_region
  	@categories = CountryCategory.all
    @category = CountryCategory.find(params[:id])
  	@countries = CountryCategory.find(params[:id]).countries
  end
end
