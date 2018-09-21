module Audit
  class Base < ApplicationRecord
    def diff
      new_value.select { |k, v| v != old_value[k] }
    end
  end
end
