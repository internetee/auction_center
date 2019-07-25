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
  def order_buttons(table_with_column)
    order_button(table_with_column, ascending_order) +
      order_button(table_with_column, descending_order)
  end

  # Chain this with order(orderable_array) in controller actions
  def orderable_array
    orderable(order_params)
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

  def order_button(table_with_column, order)
    if order == descending_order
      order_button_desc(table_with_column)
    elsif order == ascending_order
      order_button_asc(table_with_column)
    end
  end

  def order_button_desc(table_with_column)
    requested_order = { table_with_column => descending_order }
    new_hash = append_or_create_sort_hash(requested_order)

    map_of_values = { 'params' => new_hash, 'id' => "#{table_with_column}_desc_button",
                      'icon_class' => 'sort alphabet up icon' }

    link_with_icon(map_of_values)
  end

  def order_button_asc(table_with_column)
    requested_order = { table_with_column => ascending_order }
    new_hash = append_or_create_sort_hash(requested_order)

    map_of_values = { 'params' => new_hash, 'id' => "#{table_with_column}_asc_button",
                      'icon_class' => 'sort alphabet down icon' }

    link_with_icon(map_of_values)
  end

  # Prepends new order to existing order. In case existing order is on the same column as the new
  # one, it is replaced in place, without prepending it to the beginning of the hash.
  #
  # Behaviour of this method is determined by Hash.merge method's idea of prepending the argument to
  # the caller of the method.
  def append_or_create_sort_hash(requested_order)
    new_params = duplicate_params
    input_hash = new_params.to_unsafe_h

    if input_hash['order']
      input_hash['order'].merge!(requested_order)
      input_hash
    else
      input_hash.merge(order: requested_order)
    end
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
