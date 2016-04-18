class UserMailer < ApplicationMailer
	default :from => 'poedemvtur@gmail.com'

	def send_signup_email(user)
    @user = user
    mail( :to => "vania.kabashnikov@gmail.com",
    :subject => 'Thanks for signing up for our amazing app' )
  end
end
