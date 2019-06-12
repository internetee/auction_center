module OrderableHelper
  # Clean out all order parameters from current URL.
  def clear_order_button
    new_params = duplicate_params.delete('order')
    hash = new_params.to_unsafe_h

    map_of_values = {'params' => hash, 'id' => 'cancel_order_button',
                     'icon_class' => 'undo icon' }

    link_with_icon(map_of_values)
  end

  def order_buttons(table)
    # content_tag()
  end

  def order_button_desc(table_with_column)
    #
  end

  def reverse(direction)
    if direction == 'asc'
      'desc'
    elsif direction == 'desc'
      'asc'
    end
  end

  def link_with_icon(map_of_values)
    link_to(map_of_values['params'], id: map_of_values['id']) do
      content_tag(:i, nil, class: map_of_values['icon_class'])
    end
  end

  def button(direction)
    if direction == 'asc'
      content_tag(:i, nil, class: 'sort down icon')
    elsif direction == 'desc'
      content_tag(:i, nil, class: 'sort up icon')
    end
  end

  def order_params
    if duplicate_params[:order]
      duplicate_params.require(:order)
    else
      ActionController::Parameters.new
    end
  end

  def duplicate_params
    params.dup
  end

  # Returns an Array of conditions that can be chained directly to order method.
  # Makes sure that order is against allowed tables and columns that exist against those tables.
  def orderable(orderable_params)
    # parameters are hash-like object, but we cannot trust anything that comes from the user to go
    # straight into the query.
    unsafe_hash = orderable_params.to_unsafe_h
    unsafe_hash.map do |key, value|
      model_name, column = key.split('.')
      Orderable.new(model_name, column, value).condition
    end
  end
end
