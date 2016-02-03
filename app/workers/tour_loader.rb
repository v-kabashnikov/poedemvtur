require 'sletat'
class TourLoader
  include Sletat
  include Sidekiq::Worker
  sidekiq_options retry: false
  def perform(requestId, url_params)
    ls = LoadStatus.create(request_id: requestId, status: 0)
    begin
      Timeout::timeout(2.minute) do
        loop do
          sleep(1)
          load_state = get_res_data('GetLoadState', false, { requestId: requestId })

          aaData = get_res_data('GetTours', true, url_params)['aaData']

          hotel_ids = aaData.map{ |a| a[3] }.uniq - [0]
          client = soap_client
          total_tours_count = load_state.reduce(0){ |res, tour_operator| res + tour_operator["RowsCount"] }
          # begin
          if(total_tours_count > 0)
            puts hotel_ids
            hotel_ids.each do |hid|
              puts 100
              min_price_index = aaData.find_index{ |a| a[3] == hid }
              puts 101
              min_price = aaData[min_price_index][42]
              puts 102
              begin
                hotel = Hotel.get_or_update(hid, client)
              rescue => error
                puts("71 ERROR ===>> #{error.class} and #{error.message}")
              end
              puts 103
              sr = SearchResult.where(hotel_id: hotel.id, request_id: requestId).first
              puts 104
              if !sr
                puts 105
                SearchResult.create(hotel_id: hotel.id, request_id: requestId, min_price: min_price)
                puts 106
              elsif sr.min_price > min_price
                puts 107
                sr.update(min_price: min_price)
              end
            end
          end
          # rescue => error
          #   puts("4 ERROR ===>> #{error.class} and #{error.message}")
          # end
          if load_state.map{ |i| i["IsProcessed"] }.reduce(true){ |res,i| res && i }
            ls.update(status: 1)
            aaData = get_res_data('GetTours', true, url_params)['aaData']
            begin
              aaData.each do |tour|
                TourResult.create(
                  hotel_id: Hotel.find_by(sletat_id: tour[3]).id,
                  depart_date: Date.parse(tour[12]),
                  nights: tour[14],
                  depart_city: tour[33],
                  meal: tour[51],
                  room_type: tour[53],
                  request_id: requestId,
                  price: tour[42],
                  adults_number: tour[16],
                  children_number: tour[17],
                  tour_operator: tour[18]
                )
              end
            rescue => error
              puts("5 ERROR ===>> #{error.class} and #{error.message}")
            end
            break
          end
          sleep(1)
        end
      end
    rescue
      ls.update(status: 1)
    end
  end
end
