class SharedFooterFetcherJob < ApplicationJob
  include Concerns::HttpRequester

  def perform
    return unless SharedFooterFetcherJob.needs_to_run?

    api_token = Setting.find_by(code: 'voog_api_key').retrieve
    main_site_path = Setting.find_by(code: 'voog_site_url').retrieve

    translated_footers = compose_localized_footers(site: main_site_path, api_token: api_token)

    return if translated_footers.empty?

    save_localized_partials(partials: translated_footers)
  end

  def remote_languages(site:, api_token:)
    url = URI("#{site}/admin/api/languages?api_token=#{api_token}")
    response = default_get_request_response(url: url)

    return [] unless response[:status] == 200

    body = response[:body]
    languages = []
    body.each { |language| languages.append(language['code']) }
    languages
  end

  def get_translated_footer(site:, language_code:)
    url = URI.parse("#{site}/#{language_code}")
    page = Nokogiri::HTML(url.open)
    footer = page.css('.site-footer').to_html.to_s
    footer.gsub! 'href="/', "href=\"#{site}/"
    footer.gsub! 'src="/', "src=\"#{site}/"
    footer.gsub! 'fas fa-', 'icon '
    footer.gsub! 'fab fa-', 'icon '
    footer.gsub! '-square', ' square'
    footer
  end

  def compose_localized_footers(site:, api_token:)
    translated_footers = {}

    remote_languages(site: site, api_token: api_token).each do |lang|
      footer = get_translated_footer(site: site, language_code: lang)
      if (footer.include? '<footer') && (footer.include? '</footer>')
        translated_footers[lang] = footer
      end
    end
    translated_footers
  end

  def self.needs_to_run?
    Setting.find_by(code: 'voog_site_fetching_enabled').retrieve
  end

  def save_localized_partials(partials:)
    partials.keys.each do |localized_partial|
      remote_partial = RemoteViewPartial.where(name: 'footer',
                                               locale: localized_partial).first_or_create
      remote_partial.content = partials[localized_partial]
      remote_partial.save
    end
  end
end
