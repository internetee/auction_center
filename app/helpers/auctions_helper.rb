module AuctionsHelper
  # MS: need better way about these links. They are external and can change at any time,
  # breaking our website.
  def faq_link
    if I18n.locale == :et
      'https://www.internet.ee/abi-ja-info/kkk#III__ee_domeenioksjonid'
    elsif I18n.locale == :en
      'https://www.internet.ee/help-and-info/faq#III__ee_domain_auctions'
    end
  end

  def reserved_domain_names_link
    if I18n.locale == :en
      'https://www.internet.ee/eif/news/auction-schedule-of-reserved-domains'
    elsif I18n.locale == :et
      'https://www.internet.ee/eis/uudised/reserveeritud-domeenide-oksjonite-kava'
    end
  end

  def domain_name_with_embedded_colors(domain_name)
    new_domain_name = domain_name.gsub(/([0-9]+)/, "<span class='number-in-domain-name'>\\1</span>")
    sanitize(new_domain_name)
  end
end
