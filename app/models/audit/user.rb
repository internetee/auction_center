module Audit
  class User < ApplicationRecord
    self.table_name = 'audit.users'
  end
end
