module ApplicationHelper
  def application_name
    Rails.configuration.customization['application_name']
  end

  def sign_in_button(current_user)
    unless current_user
      content_tag(:li, class: "nav-item") do
        link_to(t(:sign_in), new_user_session_path, class: "nav-link")
      end
    end
  end

  def sign_out_button(current_user)
    if current_user
      content_tag(:li, class: "nav-item") do
        link_to(t(:sign_out), destroy_user_session_path, class: "nav-link", method: :delete)
      end
    end
  end
end
