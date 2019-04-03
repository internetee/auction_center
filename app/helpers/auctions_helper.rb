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
end
