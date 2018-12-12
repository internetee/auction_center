module ApplicationHelper
  def application_name
    Rails.configuration.customization['application_name']
  end

  def sign_in_links(current_user)
    content_tag(:ul, class: 'navbar-nav mt-2 my-lg-0') do
      if current_user
        content_tag(:li, class: 'nav-item') do
          link_to(t(:sign_out), destroy_user_session_path, class: 'nav-link', method: :delete)
        end
      else
        content_tag(:li, class: 'nav-item') do
          link_to(t(:sign_in), new_user_session_path, class: 'nav-link')
        end
      end
    end
  end

  def navigation_links(current_user)
    content_tag(:ul, class: 'navbar-nav mt-2 my-lg-0') do
      links(user_link_list) if current_user&.role?(User::PARTICIPANT_ROLE)
      links(administrator_link_list) if current_user&.role?(User::ADMINISTATOR_ROLE)
    end
  end

  private

  def links(links_list)
    links_list.each do |item|
      concat(
        content_tag(:li, class: 'nav-item') do
          link_to(item[:name], item[:path], class: 'nav-link')
        end
      )
    end
  end

  def user_link_list
    [{ name: t(:profile), path: user_path(current_user) },
     { name: t(:my_invoices), path: invoices_path },
     { name: t(:my_offers), path: offers_path }]
  end

  def administrator_link_list
    [{ name: t(:auctions_name), path: admin_auctions_path },
     { name: t(:results_name), path: admin_results_path },
     { name: t(:billing_profiles_name), path: admin_billing_profiles_path },
     { name: t(:users_name), path: admin_users_path },
     { name: t(:invoices_name), path: admin_invoices_path },
     { name: t(:jobs_name), path: admin_jobs_path },
     { name: t(:settings_name), path: admin_settings_path }]
  end
end
