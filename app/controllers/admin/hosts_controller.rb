module Admin
  class HostsController < Admin::ApplicationController
    include Sunrise::Controllers::Modalable

    helper_method :hosts,
                  :pager_url,
                  :hosts_base_request,
                  :host,
                  :new_crawl_form,
                  :form_filter,
                  :pages,
                  :filtered_pages,
                  :pages_to_crawl,
                  :section_pages?,
                  :section_hosts?,
                  :section_linked_emails?,
                  :section_pages_to_crawl?,
                  :section_filtered_pages?,
                  :emails

    def ajax_modal_actions
      %w[start_crawl new_crawl edit_filter update_filter]
    end

    def start_crawl
      outcome = new_crawl_form.process_with_params(params)
      if outcome.success?
        redirect_to(admin_host_path(outcome.result.host))
      else
        render :new_crawl
      end
    end

    def update_filter
      outcome = form_filter.process_with_params(params)
      if outcome.success?
        redirect_to(admin_host_path(host))
      else
        render :edit_filter
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

    def form_filter
      @new_crawl_form ||= Forms::Hosts::EditFilter.new(host: host)
    end

    def hosts
      hosts_base_request
        .with_stats(
          :number_of_pages,
          :number_of_crawled_pages,
          :number_of_linked_hosts
        )
        .reorder(number_of_linked_hosts: :desc)
        .page(params[:p])
    end

    def hosts_base_request
      @hosts_base_request =
        begin
          request =
            if section_hosts?
              Host.where(id: host.links.pluck(:id))
            else
              Host.search(params[:q])
            end

          request = request.with_domain_available.reorder(id: :desc) if params[
            :filter
          ] == 'free'
          request
        end
    end

    def pages
      host.pages.reorder("COALESCE(crawled_at::text, '') DESC").page(params[:p])
    end

    def filtered_pages
      request = host.pages

      conditions_sql = host.filter&.split("\n").map do |expression|
        "url ~ '#{expression}'"
      end.join(' OR ')

      request = request.where(conditions_sql)

      request.page(params[:p])
    end

    def pages_to_crawl
      host.pages.without_filtered_urls(host.filter).where(crawled_at: nil).page(params[:p])
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

    def section_filtered_pages?
      section_param == 'filtered_pages'
    end

    def section_pages_to_crawl?
      section_param == 'pages_to_crawl'
    end

    def section_param
      return if params[:action] != 'show'

      params['section'] || 'pages'
    end

    def pager_url(page)
      if params[:action] == 'index'
        return admin_hosts_path(p: page, filter: params[:filter])
      end
      if section_hosts?
        return admin_host_path(id: host.id, section: :hosts, p: page)
      elsif section_pages?
        return admin_host_path(id: host.id, section: :pages, p: page)
      elsif section_filtered_pages?
        return admin_host_path(id: host.id, section: :filtered_pages, p: page)
      elsif section_pages_to_crawl?
        return admin_host_path(id: host.id, section: :pages_to_crawl, p: page)
      elsif section_linked_emails?
        return(
          admin_host_path(id: host.id, section: :section_linked_emails, p: page)
        )
      end
    end
  end
end
