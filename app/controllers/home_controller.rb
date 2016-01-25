require 'open-uri'
class HomeController < ApplicationController
  extend Sletat
  def index
    # render 'index-test'
    render 'index', layout: 'home'
  end
  def test
    render 'test', layout: 'application'
  end
  def search
    updateResult = 0
    url_start = "https://module.sletat.ru/Main.svc/GetTours?login=pr@corona.travel&password=1234567&"
    s_nights = params["s_nights"].split('-')
    s_departFrom = Date.parse("18.02.2016")
    s_departTo = s_departFrom + 10.days
    url_params = {cityFromId: params[:cityFromId], countryId: params[:countryId],
      s_adults: params[:s_adults], s_kids: 0, s_nightsMin: s_nights[0], s_nightsMax: s_nights[1],
      s_priceMin: params[:s_priceMin], s_priceMax: params[:s_priceMax], s_departFrom: s_departFrom.strftime("%d/%m/%Y"),
      s_departTo: s_departTo.strftime("%d/%m/%Y"), s_hotelIsNotInStop: true, s_hasTickets: true, 
      includeDescriptions: 1, updateResult: 0}
    uri = URI(url_start + url_params.to_query)
    # binding.pry
    json = JSON.parse(open(uri).read)
    data = json['GetToursResult']['Data']
    requestId = data["requestId"]


    check_uri = URI("https://module.sletat.ru/Main.svc/GetLoadState?requestId=#{requestId}")

    10.times do
      json = JSON.parse(open(check_uri).read)
      if json["GetLoadStateResult"]["Data"].map{ |i| i["IsProcessed"] }.reduce(true){ |res,i| res && i }
       break
      end
      sleep(1.5)
    end

    url_params[:updateResult] = 1
    url_params[:requestId] = requestId
    url_params[:pageSize] = 198

    uri = URI(url_start + url_params.to_query)
    json = JSON.parse(open(uri).read)
       
    data = json['GetToursResult']['Data']


    @country = Country.find_by(sletat_id: params[:countryId].to_i).name
    @aaData = data['aaData']
    @hotels_number = @aaData.map(&:third).uniq.count
    render 'search', layout: 'home'
  end
end
