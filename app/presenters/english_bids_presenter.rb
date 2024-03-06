class EnglishBidsPresenter
  include ActionView::Helpers::TagHelper
  include ActionView::Context

  attr_reader :auction

  def initialize(auction)
    @auction = auction
  end

  def last_actual_offer
    auction.offers.order(updated_at: :desc).first
  end

  def maximum_bids
    return 'Bad auction type' if auction.platform == 'blind'
    return Money.new(0, Setting.find_by(code: 'auction_currency').retrieve) if auction.offers.empty?

    Money.new(last_actual_offer.cents, Setting.find_by(code: 'auction_currency').retrieve)
  end

  def display_ends_at
    return 'Bad auction type' if auction.platform == 'blind'

    return auction.ends_at if auction.offers.empty?

    auction.offers.order(created_at: :desc).first.created_at + auction.slipping_end.minutes + 1.minute
  end

  def bidder_name(offer, current_user, in_progress: true)
    return unless offer

    is_user_offer = offer.billing_profile.user_id == current_user&.id
    you = is_user_offer ? " (#{I18n.t('auctions.you')})" : ''
    content_tag(:span) do
      in_progress ? "#{offer.username}#{you}" : offer.billing_profile.name
    end
  end

  def current_price(offer, current_user)
    return unless offer

    is_user_offer = offer.billing_profile.user_id == current_user&.id
    username = is_user_offer ? I18n.t('auctions.you').to_s : offer.username
    content_tag(:span, class: 'current_price',
                       data: { 'user-id': offer.user_id, you: I18n.t('auctions.you') }) do
      content = "#{offer.price} "
      content << content_tag(:span, (username.nil? ? '' : "(#{username})"), class: 'bidder')
      content.html_safe
    end
  end
end
