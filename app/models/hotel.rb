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

  def self.get_or_update(hid, client)
    hotel = find_by(sletat_id: hid)
    if hotel
      if !hotel.sletat_photo_url || (Time.now - hotel.updated_at > 7.days)
        res = client.call :get_hotel_information, message: { hotel_id: hid }
        info_res = res.body[:get_hotel_information_response][:get_hotel_information_result]
        sletat_photo_url = info_res[:image_urls][:string].kind_of?(Array) ? info_res[:image_urls][:string].try(:first) : info_res[:image_urls][:string]
        hotel.update(
          sletat_photo_url: sletat_photo_url || "http://hotels.sletat.ru/i/f/#{hid}_0.jpg",
          hotel_rate: (info_res[:hotel_rate].to_f / 2).round(1),
          resort_id: Resort.find_by(sletat_id: info_res[:resort_id].to_i).try(:id),
          airport_distance: info_res[:airport_distance]
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
        airport_distance: info_res[:airport_distance]
      )
    end
    find_by(sletat_id: hid)
  end
end
