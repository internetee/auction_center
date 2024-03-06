module OrderableHelper
  # def sortable_column(_name, column, caption)
  #   tag.th caption, class: 'sorting', data: { controller: 'table--sort-link', turbo_action: 'advance',
  #                                                    action: 'click->table--sort-link#resortTable',
  #                                                    'table--sort-link-direction-value': next_direction(column),
  #                                                    'table--sort-link-column-value': column,
  #                                                    'table--sort-link-asc-class': 'sorting_asc',
  #                                                    'table--sort-link-desc-class': 'sorting_desc',
  #                                                    'table--sort-link-target': 'th' }
  # end

  # private

  # def currently_sorted?(column)
  #   params[:sort] == column.to_s
  # end

  # def next_direction(column)
  #   return unless currently_sorted?(column)

  #   params[:direction] == 'asc' ? 'desc' : 'asc'
  # end
end
