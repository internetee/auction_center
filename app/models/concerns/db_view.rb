module Concerns
  module DBView
    extend ActiveSupport::Concern

    included do
      self.primary_key = 'id'

      def self.refresh
        Scenic.database.refresh_materialized_view(table_name, concurrently: false, cascade: false)
      end

      def readonly?
        true
      end
    end
  end
end
