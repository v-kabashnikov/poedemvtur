require 'benchmark'
require 'open-uri'
require 'sletat'
class HomeController < ApplicationController
  include Sletat

  def index
  end

  def search
    s_nights = params["s_nights"].split('-')
    s_departFrom = Date.parse("18.02.2016")
    s_departTo = s_departFrom + 45.days
    url_params = { cityFromId: params[:cityFromId], countryId: params[:countryId],
                   s_adults: params[:s_adults], s_kids: 0, s_nightsMin: s_nights[0], s_nightsMax: s_nights[1],
                   s_priceMin: params[:s_priceMin], s_priceMax: params[:s_priceMax], s_departFrom: s_departFrom.strftime("%d/%m/%Y"),
                   s_departTo: s_departTo.strftime("%d/%m/%Y"), s_hotelIsNotInStop: true, s_hasTickets: true,
                   includeDescriptions: 1, updateResult: 0 }

    data = get_res_data 'GetTours', true, url_params
    requestId = data["requestId"]

    url_params[:updateResult] = 1
    url_params[:requestId] = requestId
    url_params[:pageSize] = 3000

    TourLoader.perform_async(requestId, url_params)

    @country = Country.find_by(sletat_id: params[:countryId].to_i).name
    @requestId = requestId
  end

  def check
    requestId = params[:requestId]
    @total = SearchResult.where(request_id: requestId).count
    if LoadStatus.find_by(request_id: requestId).status == 1
      @status = 'finished'
    else
      @status = 'loading'
    end
    @results = SearchResult.where(request_id: requestId).preload(hotel: [resort: [:country]]).order(min_price: :asc).limit(18)
  end

  def load_more
    @results = SearchResult.where(request_id: params[:requestId]).preload(hotel: [resort: [:country]]).order(min_price: :asc).limit(18).offset(params[:loaded])
    render 'check'
  end
end
