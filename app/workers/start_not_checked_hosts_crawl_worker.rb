class StartNotCheckedHostsCrawlWorker
  include Sidekiq::Worker
  def perform
    host_id = Page.group(:host_id).having('count(crawled_at) = 0').pluck(:host_id).first

    Pages::StartCrawler.run!(url: Host.find(host_id).pages.first.url, host_limit: 1)
    sleep(1)

    StartNotCheckedHostsCrawlWorker.perform_async
  end
end
