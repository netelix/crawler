module Pages
  class StartLinkedHostsCrawl < Mutations::Command
    required { duck :host }

    def execute
      Host
        .find(7598)
        .links
        .each { |host| StartCrawlerWorker.perform_async(host.pages.first.url, 10) }

      host.update!(linked_hosts_crawled_at: DateTime.now)
    end
  end
end
