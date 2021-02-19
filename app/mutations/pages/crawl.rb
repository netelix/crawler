module Pages
  class Crawl < Mutations::Command
    required {
      string :url
    }

    def execute
      puts "== crawling #{url}"

      fetch_page
      check_domain_availability_if_expired

      check_majestic_flows
      check_wayback_history
      check_ahref_rating

      return current_page if nokogiri_html.nil?

      internal_links.map{ |href| create_page(href) }
      external_links.map do |href|
        page = create_page(href)
        backlink_hosts = page.backlink_hosts || []
        backlink_hosts.push(host)
        page.update(backlink_hosts: backlink_hosts.uniq)
      end

      extract_title
      current_page.update!(
        emails: ExtractEmails.run!(nokogiri_html: nokogiri_html))

      current_page
    end

    def check_domain_availability_if_expired
      return if (current_page.error.nil? || !current_page.error.match?('Failed to open TCP connection to'))
      return unless current_page.domain_status.nil?

      current_page.update!(domain_status: Domains::CheckAvailability.run!(domain: domain))
    end

    def check_majestic_flows
      return unless current_page.domain_available?
    end

    def check_ahref_rating
      return unless current_page.domain_available?

      current_page.update!(ahref_note: Domains::FetchAhrefRating.run!(domain: domain))
    end

    def check_wayback_history
      return unless current_page.domain_available?

      current_page.update(history_titles: Domains::FetchHistoryTitles.run!(host: host))
    end

    def internal_links
      links.select{ |href| internal_link?(href) }.map{ |href| normalized_internal_link(href) }.uniq
    end

    def create_page(href)
      Page.find_or_create_by!(url: href.delete(' '), host: host_from_url(href))
    end

    def normalized_internal_link(href)
      href_parts = splitted_href(href).first
      href_path = href_parts[4].to_s
      href_params = href_parts[6].to_s
      href_path = ('/'+ href_path) if href_path[0] != '/'

      (href_parts[1] || protocol) + '://' + host + href_path + href_params
    end

    def external_link?(href)
      url_host = host_from_url(href)
      url_host != host
    end

    def external_links
      links.select{ |href| !internal_link?(href) }
    end

    def internal_link?(href)
      url_host = host_from_url(href)
      url_host.nil? || url_host == host
    end

    def domain
      host.split('.')[-2..-1].join('.')
    end

    def host
      host_from_url(url)
    end

    def protocol
      splitted_href(url).first.try(:[], 1)
    end

    def host_from_url(_url)
      splitted_href(_url).first.try(:[], 3)
    end

    def splitted_href(href)
      href.scan(/^(([^:\/?#]+):)?(\/\/([^\/?#]*))?([^?#]*)(\?([^#]*))?(#(.*))?/)
    end

    def links
      @links ||=
        nokogiri_html.xpath('//a').map do |a|
          a['href']
        end.compact.uniq
    end

    def extract_title
      current_page.update!(
          title: nokogiri_html.css('title').text
      )
    rescue ActiveRecord::StatementInvalid => _
      current_page.update!(
          title: nokogiri_html.css('title').text.force_encoding('iso8859-1').encode('utf-8')
      )
    end

    def current_page
      @current_page ||= begin
        page = Page.find_or_create_by!(url: url, host: host)
        page.update!(crawled_at: DateTime.now)
        page
      end
    end

    def open_page
      @open_page ||= begin
        page = HTTParty.get(url, follow_redirects: false)
        return page if page.code == 200

        if page.code.in?([301, 302])
          current_page.update(redirect_to: page.headers['location'])
          create_page(page.headers['location'])

          nil
        end
      rescue StandardError => error
        current_page.update(error: error.message)
        nil
      end
    end

    def fetch_page
      nokogiri_html
    end

    def nokogiri_html
      @nokogiri_html ||= begin
        Nokogiri::HTML(open_page.body) unless (open_page.nil? || open_page.body.empty?)
      end
    end
  end
end