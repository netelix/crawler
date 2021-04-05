module Forms
  class StartCrawl < Sunrise::Mutations::ProcessForm
    required do
      string :url
    end

    scope :host

    def execute
      page = ::Pages::Crawl.run!(url: url)
      ::StartCrawlerWorker.perform_async(url, nil);

      host.links.pluck(:id)

      page
    end
  end
end
