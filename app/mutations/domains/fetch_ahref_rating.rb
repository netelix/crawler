module Domains
  class FetchAhrefRating < Mutations::Command
    required { string :domain }

    def execute
    end

    def domain_rating
      @domain_rating ||=
        JSON.parse(HTTParty.get(
            "https://apiv2.ahrefs.com/?from=domain_rating&target=#{domain}&mode=domain&output=json&token=c0b28a6ae92465a4e5a33082aa48fac6ce9bbdac", ).body)
            .dig('domain', 'domain_rating')
    end
  end
end