module Pages
  class ExtractEmails < Mutations::Command
    EMAIL_REGEX = /[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}/

    required {
      duck :nokogiri_html
    }

    def execute
      extracted_emails
    end

    def extracted_emails
      search_for_mailto_links + search_email_in_text
    end

    def search_for_mailto_links
      links = nokogiri_html.css('a[href^="mailto:"]')
      return [] if links.nil? || links.empty?

      links.map do |link|
        link.text =~ EMAIL_REGEX ? link.text : link['href'][EMAIL_REGEX]
      end.uniq
    end

    def search_email_in_text
      emails = nokogiri_html.to_html.scrub.scan EMAIL_REGEX
      return [] if emails.nil? || emails.empty?
      emails.reject { |e| e =~ /ajax-loader@2x.gif/ }
      return [] if emails.empty?

      emails.uniq
    end
  end
end