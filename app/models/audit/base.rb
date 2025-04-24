module Audit
  class Base < ApplicationRecord
    self.abstract_class = true
    
    def diff
      new_value.reject { |k, v| v == old_value[k] }
    end
  end
end
