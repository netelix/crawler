module Admin
  class HostsController < Admin::ApplicationController
    include Sunrise::Controllers::Modalable

    helper_method :hosts,
                  :pager_url,
                  :host,
                  :new_crawl_form,
                  :pages,
                  :section_pages?,
                  :section_hosts?,
                  :section_linked_emails?,
                  :emails

    def ajax_modal_actions
      %w[start_crawl new_crawl]
    end

    def start_crawl
      outcome = new_crawl_form.process_with_params(params)
      if outcome.success?
        redirect_to(admin_host_path(outcome.result.host))
      else
        render :new_crawl
      end
    end

    def start_linked_hosts_crawl
      Pages::StartLinkedHostsCrawl.run!(host: host)

      redirect_to(admin_host_path(host, section: :linked_emails))
    end

    private

    def new_crawl_form
      @new_crawl_form ||= Forms::StartCrawl.new({})
    end

    def hosts
      request =
        if section_hosts?
          Host.where(id: host.links.pluck(:id))
        else
          Host.search(params[:q])
        end

      request
        .with_stats(
          :number_of_pages,
          :number_of_crawled_pages,
          :number_of_linked_hosts
        )
        .reorder(number_of_linked_hosts: :desc)
        .page(params[:p])
    end

    def pages
      host.pages.reorder("COALESCE(crawled_at::text, '') DESC").page(params[:p])
    end

    def emails
      Email
        .joins(:page)
        .joins(page: :host)
        .joins(page: { host: :backlinks_from })
        .select('emails.email, min(pages.id) as page_id')
        .group('emails.email')
        .order('max(emails.id) desc')
        .where(backlinks: { from_id: host.id })
        .page(params[:p])
    end

    def host
      @host ||= Host.find_by_id(params[:id])
    end

    def section_pages?
      section_param == 'pages'
    end

    def section_hosts?
      section_param == 'hosts'
    end

    def section_linked_emails?
      section_param == 'linked_emails'
    end

    def section_param
      return if params[:action] != 'show'

      params['section'] || 'pages'
    end

    def pager_url(page)
      return admin_hosts_path(p: page) if params[:action] == 'index'
      if section_hosts?
        return admin_host_path(id: host.id, section: :hosts, p: page)
      elsif section_pages?
        return admin_host_path(id: host.id, section: :pages, p: page)
      elsif section_linked_emails?
        return(
          admin_host_path(id: host.id, section: :section_linked_emails, p: page)
        )
      end
    end
  end
end
