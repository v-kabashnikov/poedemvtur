class UserMailer < ApplicationMailer
	default :from => 'zakaz@poedemvtour.ru'

	def send_signup_email(user)
   	 @user = user
     mail( :to => "jujava@mail.ru",
     :subject => 'Пользователь оставил отзыв на сайте poedemvtur' )
  	end

  	def buy_notification(mail, hotel, depart_date, arrive_date)
  		@mail = mail
      @hotel = hotel
      @depart_date = depart_date
      @arrive_date = arrive_date
  		mail( :to => @mail,
     	:subject => 'Заявка на покупку тура оставлена' )
  	end
end
