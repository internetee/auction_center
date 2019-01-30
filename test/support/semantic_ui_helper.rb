module SemanticUiHelper
  # Required by semantic-ui javascript
  def select_from_dropdown(item_text, options)
    dropdown = find_field(options[:from], visible: false).first(:xpath,".//..")
    dropdown.click
    dropdown.find(".menu .item", :text => item_text).click
  end

  def uncheck_checkbox(item_text)
    uncheck(item_text, visible: false)
  end

  def check_checkbox(item_text)
    check(item_text, visible: false)
  end
end
