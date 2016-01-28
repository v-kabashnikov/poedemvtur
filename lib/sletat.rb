require 'open-uri'

module Sletat
  # also notice the call to 'freeze'
  SERVICE_URL = "https://module.sletat.ru/Main.svc/".freeze
  LOGIN = "pr@corona.travel"
  PASS = "1234567"

  SOAP_HEADER = {
    "AuthInfo" => {
      "@xmlns" => "urn:SletatRu:DataTypes:AuthData:v1",
      "Login"  => LOGIN,
      "Password"  => PASS
    }
  }

  def soap_client
    Savon.client(wsdl: "http://module.sletat.ru/XmlGate.svc?singleWSDL", soap_header: SOAP_HEADER)
  end

  def get_data method, auth, params
    uri_schema = URI(SERVICE_URL + method + '?' + auth_str + '&' + params.to_query)
    # puts uri_schema
    json = open(uri_schema).read
    res = JSON.parse(json)
  end

  def get_res_data(method, auth = false, params = nil)
    data = get_data method, auth, params
    data["#{method}Result"]["Data"]
  end

  private
  def auth_str
    "login=#{LOGIN}&password=#{PASS}"
  end

end
