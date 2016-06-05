class UserMailer < ApplicationMailer
	default :from => 'zakaz@poedemvtour.ru'

	def send_signup_email(link)
   	 @link = link
     mail( :to => "admin@poedemvtour.ru",
     :subject => 'Пользователь оставил отзыв на сайте poedemvtur' )
  	end

  def buy_notification(email, options = {})
    email_template = EmailTemplate.find_by_slug('create_order')

    @content = MailContentParser.new(email_template, options).call

    mail(to: email, subject: email_template.subject)
	end

  def buy_notification_manager(email, options = {})
    email_template = EmailTemplate.find_by_slug('create_order_manager')

    @content = MailContentParser.new(email_template, options).call

    mail(to: emails, subject: email_template.subject)
  end
end
