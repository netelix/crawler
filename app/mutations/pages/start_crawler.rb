module Pages
  class StartCrawler < Mutations::Command
    required {
      string :url
    }
    optional {
      integer :host_limit
    }

    def execute
      page = Crawl.run!(url: url)

      sleep(2)

      StartCrawler.run!(url: next_page(page).url, host_limit: host_limit) if next_page(page)
    end

    def next_page(page)
      number_of_crawled_pages = Page.where(host: page.host).where.not(crawled_at: nil).count
      puts "checking next page after #{page.url} from host #{page.host} (#{number_of_crawled_pages} pages already crawled, limit #{host_limit})"

      return if host_limit.present? && number_of_crawled_pages > host_limit
      Page.where(host: page.host).where(crawled_at: nil).first
    end
  end
end