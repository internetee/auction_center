module OrderableHelper
  # A button to clear out current orders. To be used in templates.
  def clear_order_button
    new_params = duplicate_params
    new_params.delete('order')

    hash = new_params.to_unsafe_h

    map_of_values = { 'params' => hash, 'id' => 'cancel_order_button',
                      'icon_class' => 'undo icon' }

    link_with_icon(map_of_values)
  end

  # A button to create order buttons, ascending first. To be used in templates.
  def order_buttons(table_with_column, origin: nil)
    order_button(table_with_column, ascending_order, origin) +
      order_button(table_with_column, descending_order, origin)
  end

  # Chain this with order(orderable_array) in controller actions
  def orderable_array(default_params = {})
    params = order_params
    if params.empty?
      params = ActionController::Parameters.new(default_params) unless default_params.empty?
    end
    orderable(params)
  end

  # Returns an Array of conditions that can be chained directly to order method.
  # Makes sure that order is against allowed tables and columns that exist against those tables.
  #
  # To be used in controllers.
  def orderable(orderable_params)
    # parameters are hash-like object, but we cannot trust anything that comes from the user to go
    # straight into the query.
    unsafe_hash = orderable_params.to_unsafe_h
    unsafe_hash.map do |key, value|
      model_name, column = key.split('.')
      Orderable.new(model_name: model_name, column: column, direction: value).condition
    end
  end

  private

  def ascending_order
    'asc'
  end

  def descending_order
    'desc'
  end

  def order_button(table_with_column, order, origin)
    if order == descending_order
      order_button_with_type('desc', table_with_column, origin)
    elsif order == ascending_order
      order_button_with_type('asc', table_with_column, origin)
    end
  end

  def order_button_with_type(method, table_with_column, origin)
    desc = method == 'desc'
    requested_order = { order: {
      table_with_column => (desc ? descending_order : ascending_order),
    } }
    requested_order[:order][:origin] = origin if origin.present?

    values = { 'params' => requested_order, 'id' => "#{table_with_column}_#{method}_button",
               'icon_class' => "sort alphabet #{desc ? 'up' : 'down'} icon" }

    link_with_icon(values)
  end

  def link_with_icon(map_of_values)
    link_to(map_of_values['params'], id: map_of_values['id']) do
      content_tag(:i, nil, class: map_of_values['icon_class'])
    end
  end

  def order_params
    if duplicate_params[:order]
      duplicate_params.require(:order)
    else
      ActionController::Parameters.new
    end
  end

  # Because params object is mutable, we should make a copy of it every time we want def to
  # perform some operations on parameters.
  def duplicate_params
    params.dup
  end
end
