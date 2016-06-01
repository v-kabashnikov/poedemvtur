class CountriesController < ApplicationController
  layout 'static'	

  def index
	  @countries = Country.all
	  @categories = CountryCategory.all
	end
  
  def show
    @country = Country.find(params[:id])
  end

  def show_region
  	@categories = CountryCategory.all
    @category = CountryCategory.find(params[:id])
  	@countries = CountryCategory.find(params[:id]).countries
  end
end
