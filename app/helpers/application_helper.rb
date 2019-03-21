module ApplicationHelper
  def application_name
    Rails.configuration.customization['application_name']
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
    return unless current_user&.banned?

    ban = current_user.longest_ban

    content_tag(:div, class: 'ui message ban') do
      content_tag(:div, t(:banned, valid_until: ban.valid_until.to_date,
                                   domain_name: ban.domain_name || t(:any)),
                  class: 'header')
    end
  end

  private

  def links(links_list)
    links_list.each do |item|
      concat(
        content_tag(:li) do
          link_to(item[:name], item[:path], method: item[:method], class: 'item')
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
     { name: t(:my_offers), path: offers_path }]
  end

  def administrator_link_list
    [{ name: t(:auctions_name), path: admin_auctions_path },
     { name: t(:results_name), path: admin_results_path },
     { name: t(:billing_profiles_name), path: admin_billing_profiles_path },
     { name: t(:users_name), path: admin_users_path },
     { name: t(:bans_name), path: admin_bans_path },
     { name: t(:invoices_name), path: admin_invoices_path },
     { name: t(:jobs_name), path: admin_jobs_path },
     { name: t(:settings_name), path: admin_settings_path }]
  end
end
