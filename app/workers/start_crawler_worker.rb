class StartCrawlerWorker
  include Sidekiq::Worker

  def perform(url, host_limit)
    Pages::StartCrawler.run!(url: url, host_limit: host_limit)
  end
end
