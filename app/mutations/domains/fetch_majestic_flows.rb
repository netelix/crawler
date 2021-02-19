module Domains
  class FetchMajesticFlows < Mutations::Command
    required { string :host }

    def execute
      majestic_page
    end

    def majestic_page
      @majestic_page ||=
        Nokogiri::HTML(HTTParty.get(
            "https://fr.majestic.com/reports/site-explorer?folder=&q=#{host}&IndexDataSource=F",
            headers: {
              "authority" => "fr.majestic.com",
              "accept" => "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
              "accept-encoding" => "gzip, deflate, br",
              "accept-language" => "fr-FR,fr;q=0.9",
              "cache-control" => "no-cache",
              "cookie" => "RURI=reports%2Fsite-explorer; _gcl_au=1.1.508302623.1613658862; _ga=GA1.2.964309237.1613658862; _gid=GA1.2.1763572113.1613658862; _pk_ses.2.c4b1=1; _gat_UA-66791310-1=1; STOK=NCtFet9HFPKheiIegkU9HkBaBl; _pk_id.2.c4b1=4f9e2baa3cc4ff3e.1613658864.2.1613662102.1613658864.",
              "pragma" => "no-cache",
              "sec-fetch-dest" => "document",
              "sec-fetch-mode" => "navigate",
              "sec-fetch-site" => "none",
              "sec-fetch-user" => "?1",
              "upgrade-insecure-requests" => "1",
              "user-agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.150 Safari/537.36",
            }
        ).body)
    end
  end
end