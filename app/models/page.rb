class Page < ApplicationRecord
  belongs_to :host
  scope :from_backlinks, ->(host) {
    where("backlink_hosts::text LIKE '%#{host}%'")
  }

  scope :not_crawled, -> { where(crawled_at: nil) }
  scope :with_error, -> { where.not(error: nil) }
  scope :with_domain_failing, -> { where('error LIKE ?', 'Failed to open TCP connection to%') }
  scope :with_domain_available, -> { where(domain_status: "undelegated inactive") }
  scope :without_filtered_urls, -> (filters){
    return if filters.empty?

    request = Page.all

    filters.split("\r\n").each do |expression|
      request = request.where("url !~ '#{expression}'")
    end

    request
  }


  def domain_available?
    domain_status == "undelegated inactive"
  end
end