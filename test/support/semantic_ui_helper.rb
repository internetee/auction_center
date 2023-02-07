module SemanticUiHelper
  # Required by semantic-ui javascript
  def select_from_dropdown(item_text, options)
    # dropdown = find_field(options[:from], visible: false).first(:xpath, './/..')
    # dropdown.click

    # item = dropdown.find('.menu', visible: false).find('.item', text: item_text)
    # script = <<-JS
    #   arguments[0].scrollIntoView(true);
    # JS

    # Capybara.current_session.driver.browser.execute_script(script, item.native)
    # item.click

    # find('.ui.dropdown').click
    # find('.menu.transition.visible').find('.item', text: item_text).click

    # select_from_dropdown('Poland', from: 'user[country_code]')
    select item_text, from: 'user[country_code]'
  end

  def uncheck_checkbox(item_text)
    uncheck(item_text, visible: false)
  end

  def check_checkbox(item_text)
    check(item_text, visible: false)
  end
end
