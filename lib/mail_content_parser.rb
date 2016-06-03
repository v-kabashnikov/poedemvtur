class MailContentParser
  def initialize(email_template, options = {})
  	@email_template = email_template
  	@options = options
  end

  def call
    content = @email_template.content

    content.gsub!('{TouristName}', @options[:params][:name])
  end
end
