module Common
  module Table
    class Component < ApplicationViewComponent
      attr_reader :header_collection, :options

      def initialize(header_collection:, options: {})
        @header_collection = header_collection
        @options = options

        super()
      end

      def table_header_generator
        safe_join(header_collection.map do |item|
          option = item[:options] || {}
          item[:column].nil? ? tag.th(item[:caption], **option) : sortable_column(item[:column], item[:caption], option)
        end)
      end

      private

      def sortable_column(column, caption, option)
        tag.th caption, **option,
                        data: { controller: stimulus_controller_name_dirty,
                                action: "click->#{stimulus_controller_name_dirty}#resortTable",
                                "#{stimulus_controller_name_dirty}-direction-value": next_direction(column),
                                "#{stimulus_controller_name_dirty}-column-value": column,
                                "#{stimulus_controller_name_dirty}-frame-name-value": frame_name,
                                "#{stimulus_controller_name_dirty}-asc-class": sorting_asc_class,
                                "#{stimulus_controller_name_dirty}-desc-class": sorting_desc_class,
                                "#{stimulus_controller_name_dirty}-target": target_element_name }
      end

      def stimulus_controller_name_dirty
        'table--ordeable'
      end

      def sorting_asc_class
        'sorting_asc'
      end

      def sorting_desc_class
        'sorting_desc'
      end

      def target_element_name
        'th'
      end

      def frame_name
        'results'
      end

      def currently_sorted?(column)
        params[:sort_by] == column.to_s
      end

      def next_direction(column)
        return unless currently_sorted?(column)

        params[:sort_direction] == 'asc' ? 'desc' : 'asc'
      end
    end
  end
end
