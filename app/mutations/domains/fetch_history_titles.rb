module Domains
  class FetchHistoryTitles < Mutations::Command
    required { string :host }

    def execute
      [extract_title(last_snapshot_url)]
    end

    def last_snapshot_url
      JSON.parse(HTTParty.get("https://archive.org/wayback/available?url=#{host}").body).dig("archived_snapshots", "closest", "url")
    end

    def extract_title(url)
      return if url.nil?
      Nokogiri::HTML(HTTParty.get(url)).css('title').text
    end
  end
end