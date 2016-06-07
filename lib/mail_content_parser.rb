class MailContentParser
  attr_reader :params

  def initialize(email_template, options = {})
  	@email_template = email_template
  	@params = options.fetch(:params, {})
  end

  def call
    content = @email_template.content
    hotel = Hotel.find(params[:id])
    tour = hotel.tour_results.order(:id).find(params[:tour_id])
    date = Time.now

    content.gsub!('{TouristName}', params[:name])
    content.gsub!('{TouristSurName}', params[:surname])
    content.gsub!('{TouristEMail}', params[:email])
    content.gsub!('{TouristPhone}', params[:phone])
    content.gsub!('{TourOperatorName}', tour.tour_operator)
    content.gsub!('{HotelRang}', hotel.stars_count.to_s)
    content.gsub!('{StartDate}', tour.depart_date.strftime('%d.%m.%Y'))
    content.gsub!('{EndDate}', tour.date_end.strftime('%d.%m.%Y'))
    content.gsub!('{TotalPrice}', tour.price.to_s)
    content.gsub!('{CurrentDate}', date.strftime('%d.%m.%Y'))
    content.gsub!('{CurrentTime}', date.strftime('%H:%M'))
    content.gsub!('{PaxCount}', (tour.adults_number.to_i + tour.children_number.to_i).to_s)
    content.gsub!('{ZakazID}', tour.id.to_s)
    content.gsub!('{FromCity}', tour.depart_city)
    content.gsub!('{ToCountryName}', hotel.resort.country.name)
    content.gsub!('{ToResortName}', hotel.resort.name)
    content.gsub!('{ToHotelName}', hotel.name)
    content.gsub!('{NightsCount}', tour.nights.to_s)
    content.gsub!('{RoomType}', tour.room_type)
    content.gsub!('{MealType}', tour.meal)

    content
  end
end
