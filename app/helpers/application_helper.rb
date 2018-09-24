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
        concat(
          content_tag(:li, class: 'nav-item') do
            link_to(t(:profile), user_path(current_user), class: 'nav-link')
          end
        )
      end
      if current_user&.role?(User::ADMINISTATOR_ROLE)
        concat(
          content_tag(:li, class: 'nav-item') do
            link_to(t(:users_name), admin_users_path, class: 'nav-link')
          end
        )
      end
    end
  end
end
