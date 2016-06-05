class MailContentParser
  attr_reader :params

  def initialize(email_template, options = {})
  	@email_template = email_template
  	@params = @options.fetch(:params, {})
  end

  def call
    content = @email_template.content
    hotel = Hotel.find(params[:id])
    tour = hotel.tour_results.find(params[:tour_id])
    date = Time.now

    content.gsub!('{TouristName}', params[:name])
    content.gsub!('{TouristSurName}', params[:surname])
    content.gsub!('{TouristEMail}', params[:email])
    content.gsub!('{TouristPhone}', params[:phone])
    content.gsub!('{TourOperatorName}', tour.tour_operator)
    content.gsub!('{HotelRang}', hotel.stars_count)
    content.gsub!('{StartDate}', tour.depart_date.strftime('%d.%m.%Y'))
    content.gsub!('{EndDate}', tour.end_date.strftime('%d.%m.%Y'))
    content.gsub!('{TotalPrice}', "#{tour.price} Р")
    content.gsub!('{CurrentDate}', date.strftime('%d.%m.%Y'))
    content.gsub!('{CurrentTime}', date.strftime('%H:%M'))
  end
end
