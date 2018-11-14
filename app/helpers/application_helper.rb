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
      if current_user
        links = [{ name: t(:profile), path: user_path(current_user) },
                 { name: t(:my_offers), path: offers_path }]

        links.each do |item|
          concat(
            content_tag(:li, class: 'nav-item') do
              link_to(item[:name], item[:path], class: 'nav-link')
            end
          )
        end
      end

      if current_user&.role?(User::ADMINISTATOR_ROLE)
        links = [{ name: t(:auctions_name), path: admin_auctions_path },
                 { name: t(:results_name), path: admin_results_path },
                 { name: t(:billing_profiles_name), path: admin_billing_profiles_path },
                 { name: t(:users_name), path: admin_users_path },
                 { name: t(:settings_name), path: admin_settings_path }]

        links.each do |item|
          concat(
            content_tag(:li, class: 'nav-item') do
              link_to(item[:name], item[:path], class: 'nav-link')
            end
          )
        end
      end
    end
  end
end
