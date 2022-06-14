module OrderableHelper
  def sort_link_to(name, column)
    if direction_indicator(column).nil?
      dir = content_tag(:i, nil, class: 'sort alphabet up icon')
      name = raw("#{name} #{dir}")
    else
      name = raw("#{name} #{direction_indicator(column)}")
    end

    params = request.params.merge(sort: column, direction: next_direction(column))

    link_to name, params, data: {
      turbo_action: 'advance',
      action: 'turbo:click->sort-link#updateForm'
    }
  end

  def next_direction(column)
    if currently_sorted?(column)
      params[:direction] == 'asc' ? 'desc' : 'asc'
    else
      'asc'
    end
  end

  def direction_indicator(column)
    if currently_sorted?(column)
      content_tag(:i, nil, class: "sort alphabet #{next_direction(column) == 'asc' ? 'up' : 'down'} icon")
    end
  end

  def currently_sorted?(column)
    params[:sort] == column.to_s
  end
end
