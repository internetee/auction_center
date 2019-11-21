class SharedComponentsFetcherJob < ApplicationJob
  def perform
    api_token = '997bfb01389be0ea8ab300ec77618912'
    main_site_path = 'https://www.internet.ee'
    storage_directory = 'storage/partials'

    translated_footers = {}

    remote_languages(site: main_site_path, api_token: api_token).each do |lang|
      translated_footers[lang] = get_translated_footer(site: main_site_path, language_code: lang)
    end

    create_storage_directory(directory: storage_directory)
    write_localized_partials(partials: translated_footers, directory: storage_directory)
  end

  def remote_languages(site:, api_token:)
    response = Http.get("#{site}/admin/api/languages?api_token=#{api_token}", {})
    body = JSON.parse(response.body)
    languages = []
    body.each { |language| languages.append(language['code']) }
    languages
  end

  def get_translated_footer(site:, language_code:)
    page = Nokogiri::HTML(open("#{site}/#{language_code}"))
    footer = page.css('.site-footer').to_html.to_s
    footer.gsub! 'href="/', "href=\"#{site}/"
    footer.gsub! 'src="/', "src=\"#{site}/"
    footer.gsub! 'fas fa-', 'icon '
    footer.gsub! 'fab fa-', 'icon '
    footer.gsub! '-square', ' square'
    footer
  end

  def self.needs_to_run?
    Invoice.pending_payment_reminder.any?
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
