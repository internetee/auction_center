module ApplicationHelper
  def application_name
    Rails.configuration.customization['application_name']
  end

  def google_analytics
    tracking_id = Rails.configuration.customization.dig(:google_analytics, :tracking_id)
    GoogleAnalytics.new(tracking_id: tracking_id)
  end

  def navigation_links(current_user)
    content_tag(:ul) do
      links(user_link_list) if current_user&.role?(User::PARTICIPANT_ROLE)
      links(administrator_link_list) if current_user&.role?(User::ADMINISTATOR_ROLE)
    end
  end

  def locale_links
    content_tag(:ul) do
      links(locale_link_list)
    end
  end

  def banned_banner
    return unless current_user&.current_bans

    domains, valid_until = current_user&.current_bans
    message = ban_error_message(domains, valid_until)
    return unless message

    content_tag(:div, class: 'ui message ban') do
      result = content_tag(:div, message, class: 'header')
      if eligible_violations_present?(domains: domains)
        result << content_tag(:p, violation_message(domains.count), class: 'violation-message')
      end
      result
    end
  end

  def start_of_procedure
    Rails.configuration.customization[:start_of_procedure]
  end

  def end_of_procdure
    Rails.configuration.customization[:end_of_procedure]
  end

  private

  def ban_error_message(domains, valid_until)
    if current_user&.completely_banned?
      t('auctions.banned_completely', valid_until: valid_until.to_date,
                                      ban_number_of_strikes: Setting.find_by(
                                        code: 'ban_number_of_strikes'
                                      ).retrieve)
    else
      I18n.t('auctions.banned', domain_names: domains.join(', '))
    end
  end

  def violation_message(domains_count)
    link = Setting.find_by(code: 'violations_count_regulations_link').retrieve
    t('auctions.violation_message_html', violations_count_regulations_link: link,
                                         violations_count: domains_count,
                                         ban_number_of_strikes: Setting.find_by(
                                           code: 'ban_number_of_strikes'
                                         ).retrieve)
  end

  def eligible_violations_present?(domains: nil)
    num_of_strikes = Setting.find_by(code: 'ban_number_of_strikes').retrieve
    return true if domains && domains.count < num_of_strikes

    false
  end

  def links(links_list)
    links_list.each do |item|
      concat(
        content_tag(:li) do
          link_to(item[:name], item[:path], method: item[:method], class: 'item', data: item[:data])
        end
      )
    end
  end

  def locale_link_list
    locales = I18n.available_locales.reject { |item| item == I18n.locale }

    items = locales.map do |item|
      { name: I18n.t(:in_local_language, locale: item), path: locale_path(locale: item),
        method: :put }
    end

    items
  end

  def user_link_list
    [{ name: t(:auctions_name), path: auctions_path },
     { name: t(:profile), path: user_path(current_user.uuid) },
     { name: t(:my_invoices), path: invoices_path },
     { name: t(:my_offers), path: offers_path },
     { name: t(:my_wishlist), path: wishlist_items_path }]
  end

  def administrator_link_list
    [{ name: t(:auctions_name), path: admin_auctions_path },
     { name: t(:results_name), path: admin_results_path },
     { name: t(:finished_auctions), path: admin_finished_auctions_index_path },
     { name: t(:billing_profiles_name), path: admin_billing_profiles_path },
     { name: t(:users_name), path: admin_users_path },
     { name: t(:bans_name), path: admin_bans_path },
     { name: t(:invoices_name), path: admin_invoices_path },
     { name: t(:jobs_name), path: admin_jobs_path },
     { name: t(:settings_name), path: admin_settings_path },
     { name: t(:statistics_name), path: admin_statistics_path, data: { turbolinks: false } }]
  end

  def cached_footer
    Rails.cache.fetch("footer/#{I18n.locale}_partial", expires_in: 12.hours) do
      RemoteViewPartial.find_by(name: 'footer', locale: I18n.locale)
    end
  end
end
