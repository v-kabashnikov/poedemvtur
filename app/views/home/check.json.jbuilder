json.hotels @results do |res|
	json.image_url res.hotel.sletat_photo_url
	json.rating res.hotel.hotel_rate
	json.name res.hotel.name
	json.id res.hotel.id
	json.stars_count res.hotel.stars_count
	json.price res.min_price
	json.position_info res.hotel.position_info
end

json.status @status
json.total @total
