class UserMailer < ApplicationMailer
	default :from => 'poedemvtur@app.com'

	def send_signup_email(user)
    @user = user
    mail( :to => "jujava@mail.ru",
    :subject => 'Пользователь оставил отзыв на сайте poedemvtur' )
  end
end
