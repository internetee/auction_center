class SharedComponentsFetcherJob < ApplicationJob
  include Concerns::HttpRequester

  def perform
    api_token = Setting.voog_api_key
    main_site_path = Setting.voog_site_url
    storage_directory = 'storage/partials'

    translated_footers = {}

    remote_languages(site: main_site_path, api_token: api_token).each do |lang|
      translated_footers[lang] = get_translated_footer(site: main_site_path, language_code: lang)
    end

    return if translated_footers.empty?

    create_storage_directory(directory: storage_directory)
    write_localized_partials(partials: translated_footers, directory: storage_directory)
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

  def create_storage_directory(directory:)
    FileUtils.mkdir_p(directory) unless File.exist?(directory)
  end

  def write_localized_partials(partials:, directory:)
    partials.keys.each do |localized_partial|
      File.open("#{directory}/footer_#{localized_partial}.html", 'w') do |file|
        file.write(partials[localized_partial])
      end
    end
  end
end
