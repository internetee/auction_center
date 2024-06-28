module ApplicationHelper
  include PagyHelper
  include OrderableHelper

  def application_name
    Rails.configuration.customization['application_name']
  end

  def google_analytics
    tracking_id = Rails.configuration.customization.dig(:google_analytics, :tracking_id)
    GoogleAnalytics.new(tracking_id:)
  end

  def component(name, *args, **kwargs, &block)
    component = name.to_s.camelize.constantize::Component
    render(component.new(*args, **kwargs), &block)
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

  def show_cookie_dialog?
    cookies[:cookie_dialog] != 'accepted'
  end

  def show_google_analytics?
    cookies[:google_analytics] == 'accepted'
  end

  private

  def links(links_list)
    links_list.each do |item|
      concat(
        content_tag(:li) do
          link_to(item[:name], item[:path], method: item[:method],
                                            class: "item #{'active' if current_page?(item[:path])}",
                                            data: item[:data])
        end
      )
    end
  end

  def locale_link_list
    locales = I18n.available_locales.reject { |item| item == I18n.locale }

    locales.map do |item|
      { name: I18n.t(:in_local_language, locale: item), path: locale_path(locale: item),
        method: :put, data: { "turbo-method": 'put' } }
    end
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
     { name: t(:paid_deposits_name), path: admin_paid_deposits_path },
     { name: t(:statistics_name), path: admin_statistics_path, data: { turbolinks: false } }]
  end

  def cached_footer
    Rails.cache.fetch("footer/#{I18n.locale}_partial", expires_in: 12.hours) do
      RemoteViewPartial.find_by(name: 'footer', locale: I18n.locale)
    end
  end
end
