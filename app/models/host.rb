class Host < ApplicationRecord
  has_many :pages

  has_many :backlinks_from, foreign_key: 'to_id', class_name: 'Backlink'
  has_many :backlinks, through: :backlinks_from, source: :backlink_from

  has_many :links_to, foreign_key: 'from_id', class_name: 'Backlink'
  has_many :links, through: :links_to, source: :backlink_to

  scope :search, ->(query) {
    return if query.blank?

    where('hosts.host LIKE ?', "%#{query}%")
  }
  scope :with_domain_available,
        -> { where(domain_status: 'undelegated inactive') }
  scope :number_of_pages,
        -> {
          joins("LEFT JOIN pages ON host_id = hosts.id")
            .group(:id)
            .select("hosts.id, count('pages.id') as number_of_pages")
        }
  scope :number_of_crawled_pages,
        -> {
          joins("LEFT JOIN pages ON host_id = hosts.id")
            .group(:id)
            .where("crawled_at IS NOT NULL")
            .select("hosts.id, count('pages.id') as number_of_crawled_pages")
        }

  scope :number_of_linked_hosts,
        -> {
          joins("LEFT JOIN backlinks ON hosts.id = from_id")
            .group(:id)
            .select(
              'hosts.id, count(DISTINCT to_id) as number_of_linked_hosts'
            )
        }
  scope :with_stats,
        -> (*subrequests){
          request = select("hosts.*, #{subrequests.join(',')}")
          subrequests.each do |subrequest|
            request = request.joins("LEFT JOIN (#{Host.send(subrequest).to_sql}) #{subrequest} ON #{subrequest}.id = hosts.id")
          end
          request
        }

  def domain_available?
    domain_status == 'undelegated inactive'
  end
end
