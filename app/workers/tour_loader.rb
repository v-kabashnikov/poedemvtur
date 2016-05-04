require 'sletat'
class TourLoader
  include Sletat
  include Sidekiq::Worker
  sidekiq_options retry: false
  def perform(requestId, url_params)
    ls = LoadStatus.find_by(request_id: requestId)    
    begin
      Timeout::timeout(4.minute) do
        loop do
          sleep(1)
          load_state = get_res_data('GetLoadState', false, { requestId: requestId })

          aaData = get_res_data('GetTours', true, url_params)['aaData']

          hotel_ids = aaData.map{ |a| a[3] }.uniq - [0]
          total_tours_count = load_state.reduce(0){ |res, tour_operator| res + tour_operator["RowsCount"] }
          if(total_tours_count > 0)
            hotel_ids.each do |hid|
              min_price_index = aaData.find_index{ |a| a[3] == hid }
              min_price = aaData[min_price_index][42]
              meal = aaData[min_price_index][10]
              # meal = 'Завтраки' if meal == 'Только завтрак'
              # [10,36,41,51,61].each{|i| puts "#{i} #{aaData[min_price_index][i]}"}
              depart_date = I18n.localize(Date.parse(aaData[min_price_index][12]), format: "%-d %B")
              nights = aaData[min_price_index][14]
              hotel = Hotel.get_or_update(hid)
              sr = SearchResult.where(hotel_id: hotel.id, request_id: requestId).first
              if !sr
                SearchResult.transaction do
                  unless hotel.sletat_photo_url.nil?
                    p "11111111111111111111111111"
                     SearchResult.connection.execute("INSERT INTO search_results (hotel_id, request_id, min_price, meal, depart_date, nights) VALUES ( '#{hotel.id}', '#{requestId}', '#{min_price}', '#{meal}', '#{depart_date}', '#{nights}')")
                  end
                end
              elsif sr.min_price > min_price
                sr.update(min_price: min_price, meal: meal, depart_date: depart_date, nights: nights)
              end
            end
            # ls.update(results: aaData)
          end
          if load_state.map{ |i| i["IsProcessed"] }.reduce(true){ |res,i| res && i }
            mainData = get_res_data('GetTours', true, url_params)
            aaData = mainData['aaData']
            puts "is_processed #{aaData.count}"

            #puts mainData["visa"]
            TourResult.transaction do
              aaData.each do |tour|
                hotel_id = Hotel.connection.execute("select hotels.* from hotels where hotels.sletat_id = '#{tour[3]}'")[0]["id"]
                Hotel.find(hotel_id).update_columns(beach_line: tour[87])
                puts tour[87]
                #parameters = { sourceId: tour[1], offerId: tour[0], currencyAlias: "RUB", requestId: requestId, countryId: countryId }
                #flight_data = get_res_data 'ActualizePrice', true, parameters
                TourResult.connection.execute("INSERT INTO tour_results (offer_id, source_id, hotel_id, depart_date, nights, depart_city, meal, room_type, request_id, price, adults_number, children_number, tour_operator) VALUES ( '#{tour[0]}', '#{tour[1]}', '#{hotel_id}', '#{Date.parse(tour[12])}', '#{tour[14]}', '#{tour[33]}', '#{tour[51]}', '#{tour[53]}', '#{requestId}', '#{tour[42]}', '#{tour[16]}', '#{tour[17]}', '#{tour[18]}')")
              end
            end
            ls.update(status: 1)
            # ls.update(status: 1, results: aaData)
            break
          end
          sleep(1)
        end
      end
    rescue => error
      puts("000 ERROR ===>> #{error.class} and #{error.message}")
      aaData = get_res_data('GetTours', true, url_params)['aaData']
      puts "is_processed #{aaData.count}"
      TourResult.transaction do
        aaData.each do |tour|
          hotel_id = Hotel.connection.execute("select hotels.* from hotels where hotels.sletat_id = '#{tour[3]}'")[0]["id"]
          Hotel.find(hotel_id).update_columns(beach_line: tour[87])
          puts tour[87]
          #parameters = { sourceId: tour[1], offerId: tour[0], currencyAlias: "RUB", requestId: requestId, countryId: countryId }
          #flight_data = get_res_data 'ActualizePrice', true, parameters
          TourResult.connection.execute("INSERT INTO tour_results (offer_id, source_id, hotel_id, depart_date, nights, depart_city, meal, room_type, request_id, price, adults_number, children_number, tour_operator) VALUES ( '#{tour[0]}', '#{tour[1]}', '#{hotel_id}', '#{Date.parse(tour[12])}', '#{tour[14]}', '#{tour[33]}', '#{tour[51]}', '#{tour[53]}', '#{requestId}', '#{tour[42]}', '#{tour[16]}', '#{tour[17]}', '#{tour[18]}')")
        end
      end
      ls.update(status: 1)
      # ls.update(status: 1, results: aaData)
    end
  end
end
