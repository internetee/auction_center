class AuctionPresenter < SimpleDelegator
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Context
  include Rails.application.routes.url_helpers

  def auction_offer_button(current_user)
    if english?
      english_auction_button(current_user)
    else
      blind_auction_button
    end
  end

  def english_auction_button(current_user)
    return default_english_auction_button if current_user.nil?

    if users_offer_uuid
      define_english_auction_button url: edit_english_offer_path(users_offer_uuid),
                                    current_user: current_user
    else
      define_english_auction_button url: new_auction_english_offer_path(auction_uuid: uuid),
                                    current_user: current_user
    end
  end

  def blind_auction_button
    if users_offer_uuid
      content_tag(:div) do
        define_blind_auction_button(url: edit_offer_path(users_offer_uuid),
                                    text: I18n.t('auctions.edit_your_offer'),
                                    color: 'blue') + delete_auction_button
      end
    else
      define_blind_auction_button(url: new_auction_offer_path(auction_uuid: uuid),
                                  text: I18n.t('auctions.submit_offer'),
                                  color: 'blue')
    end
  end

  private

  def delete_auction_button
    content_tag(:a, href: offer_path(users_offer_uuid),
                    data: { method: :delete, confirm: I18n.t(:are_you_sure) },
                    class: 'ui button red') do
      I18n.t('auctions.delete_your_offer')
    end
  end

  def define_blind_auction_button(url:, text:, color:)
    content_tag(:a, href: url, class: "ui button #{color}") do
      text
    end
  end

  def default_english_auction_button
    content_tag(:a, href: new_auction_english_offer_path(auction_uuid: uuid),
                    class: 'bid_button ui button blue') do
      I18n.t('auctions.bid')
    end
  end

  def define_english_auction_button(url:, current_user:)
    content_tag(:a, href: url,
                    class: "ui button #{allow_to_set_bid?(current_user) ? 'blue' : 'orange'}") do
      participate_bid_text(current_user)
    end
  end

  def participate_bid_text(current_user)
    return I18n.t('auctions.bid') if current_user.nil?

    allow_to_set_bid?(current_user) ? I18n.t('auctions.bid') : I18n.t('auctions.participate')
  end
end
