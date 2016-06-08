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
      where('hotels.hotel_rate IS NOT NULL').
      order('resorts.name, hotels.hotel_rate DESC').
      limit(20)

    @resorts_without_season = @country.resorts.where('season_start > ?', Time.now)

    render layout: false
  end

  def resort_items
    populate

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

  private

  def populate
    @country = Country.find(params[:id])
    @hotels = @country.hotels

    @resorts = Resort.
      where(country_id: @country.id).
      where('season_end >= ? AND season_start <= ?', Time.now, Time.now).
      paginate(page: params[:page] || 1, per_page: 5)

    @min_prices = {}

    @hotels.
      joins(:search_results).
      select('hotels.resort_id, search_results.min_price').
      order(:min_price).
      each do |res|
        @min_prices[res['resort_id'].to_i] ||= res['price'].to_f
      end
  end
end
