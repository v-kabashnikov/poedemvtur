json.resorts @resorts do |res|
	json.type "resort"
	json.id res.id
	json.name res.name
	json.country res.country.name if res.country
end


json.hotels @hotels do |res|
	json.type "hotel"
	json.id res.id
	json.name res.name
	json.country res.resort.country.name if res
end


json.countries @countries do |res|
	json.type "country"
	json.id res.id
	json.name res.name
	json.country res.name if res
end



