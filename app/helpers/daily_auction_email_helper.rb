module DailyAuctionEmailHelper
  def daily_summary_link
    if current_user&.daily_summary
      link_to_toggle_sub(user_toggle_sub_path) { mail_icon_with_check }
    elsif current_user
      link_to_toggle_sub(user_toggle_sub_path(current_user)) { mail_icon_blank }
    else
      link_to_toggle_sub(user_edit_authwall_path) { mail_icon_blank }
    end
  end

  private

  def link_to_toggle_sub(path)
    hint = link_hint(current_user)
    link_to(path,
            data: { tooltip: hint,
                    inverted: '' },
            class: 'daily-summary-link ui icon primary basic button') do
      yield
    end
  end

  def link_hint(user = nil)
    if user&.daily_summary
      t('.auction_list_unsubscribe_tooltip')
    else
      t('.auction_list_tooltip')
    end
  end

  def mail_icon_with_check
    content_tag(:i, '', class: 'big icons') do
      concat(content_tag(:i, '', class: 'mail icon no_margin'))
      concat(content_tag(:i, '',
                         class: 'top right corner green check icon'))
    end
  end

  def mail_icon_blank
    content_tag(:i, '', class: 'big icons') do
      concat(content_tag(:i, '', class: 'mail icon'))
    end
  end
end
