class Hotel < ActiveRecord::Base
  belongs_to :resort
  belongs_to :star
  belongs_to :resort
  has_many :search_results
  has_many :reviews

  def position_info
    arr = []
    arr << resort.country.name if resort
    arr << resort.name if resort
    arr << "#{airport_distance.to_i} км от аэропорта" if airport_distance
    arr.join(', ')
  end

  def stars_count
    star.name.to_i if star
  end

  def self.get_or_update(hid, client)
    hotel = find_by(sletat_id: hid)
    if hotel
      if (!hotel.sletat_photo_url || (Time.now - hotel.updated_at > 7.seconds))
        res = client.call :get_hotel_information, message: { hotel_id: hid }
        info_res = res.body[:get_hotel_information_response][:get_hotel_information_result]
        sletat_photo_url = info_res[:image_urls][:string].kind_of?(Array) ? info_res[:image_urls][:string].try(:first) : info_res[:image_urls][:string]
        # puts "IMAGE_COUNT = #{info_res[:image_count]}"
        hotel.update(
          sletat_photo_url: sletat_photo_url || "http://hotels.sletat.ru/i/f/#{hid}_0.jpg",
          hotel_rate: info_res[:hotel_rate],
          resort_id: Resort.find_by(sletat_id: info_res[:resort_id].to_i).try(:id),
          airport_distance: info_res[:airport_distance],
          old_cyrillic_name: info_res[:old_cyrillic_name],
          old_latin_name: info_res[:old_latin_name],
          rating_meal: info_res[:rating_meal],
          rating_overall: info_res[:rating_overall],
          rating_place: info_res[:rating_place],
          rating_service: info_res[:rating_service],
          sletat_description: info_res[:description],
          city_center_distance: info_res[:city_center_distance],
          beach_line: info_res[:beach_line],
          district: info_res[:district],
          latitude: info_res[:latitude],
          longitude: info_res[:longitude],
          star_id: Star.find_by(sletat_id: info_res[:star_id]).try(:id)
        )

        res_reviews = client.call :get_hotel_comments, message: { hotel_id: hid }
        reviews_arr = res_reviews.body[:get_hotel_comments_response][:get_hotel_comments_result][:hotel_comment]
        exist_reviews = Review.where(hotel_id: hotel.id).where.not(sletat_id: nil)
        puts "updating hotel #{hotel.id}"

        if reviews_arr && exist_reviews.count < reviews_arr.count
          exist_reviews_ids = Review.where(hotel_id: hotel.id).where.not(sletat_id: nil).pluck(:sletat_id)
          # binding.pry
          reviews_arr = reviews_arr.kind_of?(Array) ? reviews_arr: ([] << reviews_arr)
          puts "#{reviews_arr.count} отзывов для отеля #{hotel.id}"
          reviews_arr.each do |review|
            puts '1'
            # binding.pry
            unless exist_reviews_ids.include? review[:id]
              puts '2'
              # binding.pry
              begin
                puts review[:create_date_formatted]
                Review.create(
                  hotel_id: hotel.id,
                  name: review[:user_name],
                  comment: review[:positive].to_s + review[:negative].to_s,
                  date: (Date.parse(review[:create_date_formatted]) if review[:create_date_formatted]),
                  rate: review[:rate],
                  sletat_id: review[:id]
                )

              rescue => error
                puts("ERROR ===>> #{error.class} and #{error.message}")
              end
            end
          end
        end
      end
    else
      res = client.call :get_hotel_information, message: { hotel_id: hid }
      info_res = res.body[:get_hotel_information_response][:get_hotel_information_result]
      hotel = Hotel.create(
        sletat_id: hid,
        name: info_res[:name],
        sletat_photo_url: info_res[:image_urls][:string].try(:first) || "http://hotels.sletat.ru/i/f/#{hid}_0.jpg",
        hotel_rate: info_res[:hotel_rate],
        resort_id: Resort.find_by(sletat_id: info_res[:resort_id].to_i).try(:id),
        airport_distance: info_res[:airport_distance],
        old_cyrillic_name: info_res[:old_cyrillic_name],
        old_latin_name: info_res[:old_latin_name],
        rating_meal: info_res[:rating_meal],
        rating_overall: info_res[:rating_overall],
        rating_place: info_res[:rating_place],
        rating_service: info_res[:rating_service],
        sletat_description: info_res[:description],
        city_center_distance: info_res[:city_center_distance],
        beach_line: info_res[:beach_line],
        district: info_res[:district],
        latitude: info_res[:latitude],
        longitude: info_res[:longitude],
        star_id: Star.find_by(sletat_id: info_res[:star_id]).try(:id)
      )
      puts "creating hotel #{hotel.id}"
      res_reviews = client.call :get_hotel_comments, message: { hotel_id: hid }
      reviews_arr = res_reviews.body[:get_hotel_comments_response][:get_hotel_comments_result][:hotel_comment]
      reviews_arr = reviews_arr.kind_of?(Array) ? reviews_arr: ([] << reviews_arr)
          puts "#{reviews_arr.count} отзывов для отеля #{hotel.id}"
      reviews_arr.each do |review|
        puts '0'
        Review.create(
          hotel_id: hotel.id,
          name: review[:user_name],
          comment: review[:positive].to_s + review[:negative].to_s,
          date: (Date.parse(review[:create_date_formatted]) if review[:create_date_formatted]),
          rate: review[:rate],
          sletat_id: review[:id]
        )
      end
    end
    find_by(sletat_id: hid)
  end
end
