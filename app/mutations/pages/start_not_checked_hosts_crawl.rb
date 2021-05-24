module Pages
  class StartNotCheckedHostsCrawl < Mutations::Command

    def execute
      host = Host.with_stats(:number_of_crawled_pages).where("number_of_crawled_pages.number_of_crawled_pages IS NULL").where(domain_status: nil).joins(:pages).where(pages_hosts: {error: nil}).first

      Pages::StartCrawler.run!(url: host.pages.first.url, host_limit: 1)
      sleep(1)

      StartNotCheckedHostsCrawl.run!
    end
  end
end
