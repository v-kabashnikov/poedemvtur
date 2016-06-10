class CountriesController < ApplicationController
  layout 'static'

  def index
	  @countries = Country.all
	  @categories = CountryCategory.all
	end

  def show
    populate

    @popular_resorts = @hotels.
      select('DISTINCT ON (name) resorts.name, hotels.hotel_rate').
      where('hotels.hotel_rate IS NOT NULL AND hotels.hotel_rate > 0.01').
      order('resorts.name, hotels.hotel_rate DESC').
      limit(20)

    @resorts_without_season = @country.
      resorts.
      joins(:resort_dates).
      includes(:resort_dates).
      where('resort_dates.season_start > ? OR resort_dates.season_start IS NULL', Time.now).order(:name)

    render layout: false
  end

  def resort_items
    populate

    render partial: 'resort_items', layout: false
  end

  def show_region
  	@categories = CountryCategory.all
    @category = CountryCategory.find(params[:id])
  	@countries = CountryCategory.find(params[:id]).countries
  end

  private

  def populate
    @country = Country.find(params[:id])
    @hotels = @country.hotels

    @resorts = Resort.
      where(country_id: @country.id).
      joins(:resort_dates).
      includes(:resort_dates).
      where('resort_dates.season_end >= ? AND resort_dates.season_start <= ?', Time.now, Time.now).
      order(:name).
      paginate(page: params[:page] || 1, per_page: 5)

    @min_prices = {}

    @hotels.
      joins(:search_results).
      select('hotels.resort_id, search_results.min_price').
      where('search_results.min_price > 0.01').
      order(:min_price).
      each do |res|
        @min_prices[res['resort_id'].to_i] ||= res['min_price'].to_i
      end
  end
end
