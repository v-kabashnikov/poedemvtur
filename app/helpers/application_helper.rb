module ApplicationHelper
  def date_filter
  	date = (Time.now + 3.days).to_date

  	date.strftime('%d') + Russian.strftime(date, '%B').mb_chars.capitalize[0..2].to_s
  end
end
