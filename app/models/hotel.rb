class Hotel < ActiveRecord::Base
  belongs_to :resort
  belongs_to :star
  belongs_to :resort
  has_many :search_results

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
        hotel.update(
          sletat_photo_url: sletat_photo_url || "http://hotels.sletat.ru/i/f/#{hid}_0.jpg",
          hotel_rate: (info_res[:hotel_rate].to_f / 2).round(1),
          resort_id: Resort.find_by(sletat_id: info_res[:resort_id].to_i).try(:id),
          airport_distance: info_res[:airport_distance],
          old_cyrillic_name: info_res[:old_cyrillic_name],
          old_latin_name: info_res[:old_latin_name],
          rating_meal: info_res[:rating_meal],
          rating_overall: info_res[:rating_overall],
          rating_place: info_res[:rating_place],
          rating_service: info_res[:rating_service],
          sletat_description: info_res[:sletat_description],
          city_center_distance: info_res[:city_center_distance],
          beach_line: info_res[:beach_line],
          district: info_res[:district],
          latitude: info_res[:latitude],
          longitude: info_res[:longitude],
          star_id: Star.find_by(sletat_id: info_res[:star_id]).try(:id)
        )
      end
    else
      res = client.call :get_hotel_information, message: { hotel_id: hid }
      info_res = res.body[:get_hotel_information_response][:get_hotel_information_result]
      Hotel.create(
        sletat_id: hid,
        name: info_res[:name],
        sletat_photo_url: info_res[:image_urls][:string].try(:first) || "http://hotels.sletat.ru/i/f/#{hid}_0.jpg",
        hotel_rate: (info_res[:hotel_rate].to_f / 2).round(1),
        resort_id: Resort.find_by(sletat_id: info_res[:resort_id].to_i).try(:id),
        airport_distance: info_res[:airport_distance],
        old_cyrillic_name: info_res[:old_cyrillic_name],
        old_latin_name: info_res[:old_latin_name],
        rating_meal: info_res[:rating_meal],
        rating_overall: info_res[:rating_overall],
        rating_place: info_res[:rating_place],
        rating_service: info_res[:rating_service],
        sletat_description: info_res[:sletat_description],
        city_center_distance: info_res[:city_center_distance],
        beach_line: info_res[:beach_line],
        district: info_res[:district],
        latitude: info_res[:latitude],
        longitude: info_res[:longitude],
        star_id: Star.find_by(sletat_id: info_res[:star_id]).try(:id)
      )
    end
    find_by(sletat_id: hid)
  end
end
