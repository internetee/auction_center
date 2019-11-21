class SharedComponentsFetcherJob < ApplicationJob
  include Concerns::HttpRequester

  def perform
    api_token = Setting.voog_api_key
    main_site_path = Setting.voog_site_url

    translated_footers = {}

    remote_languages(site: main_site_path, api_token: api_token).each do |lang|
      translated_footers[lang] = get_translated_footer(site: main_site_path, language_code: lang)
    end

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

  def self.needs_to_run?
    Setting.voog_site_fetching_enabled?
  end

  def save_localized_partials(partials:)
    partials.keys.each do |localized_partial|
      remote_partial = RemoteViewPartial.where(name: "footer_#{localized_partial}").first_or_create
      remote_partial.content = partials[localized_partial]
      remote_partial.save!
    end
  end
end
