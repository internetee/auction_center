module ComponentHelpers
  def route
    Rails.application.routes.url_helpers
  end

  def show_components_html
    rendered_content
  end
end
