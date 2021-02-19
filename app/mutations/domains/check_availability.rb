module Domains
  class CheckAvailability < Mutations::Command
    required { string :domain }

    def execute
      url = URI("https://domainr.p.rapidapi.com/v2/status?mashape-key=bea3a1f3a3mshf48ac248e4f1a46p116ab7jsn4bf7d005be73&domain=#{domain}")

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Get.new(url)
      request["x-rapidapi-key"] = 'bea3a1f3a3mshf48ac248e4f1a46p116ab7jsn4bf7d005be73'
      request["x-rapidapi-host"] = 'domainr.p.rapidapi.com'

      response = http.request(request)
      JSON.parse(response.read_body)['status'].first['status']
    end
  end
end